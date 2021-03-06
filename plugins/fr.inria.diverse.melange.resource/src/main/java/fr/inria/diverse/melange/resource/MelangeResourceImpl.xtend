package fr.inria.diverse.melange.resource

import fr.inria.diverse.melange.adapters.EObjectAdapter
import fr.inria.diverse.melange.resource.loader.DozerLoader
import org.eclipse.emf.common.util.AbstractTreeIterator
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.xtend.lib.annotations.Delegate
import fr.inria.diverse.melange.resource.MelangeRegistry.LanguageDescriptor

class MelangeResourceImpl implements Resource.Internal
{
	@Delegate Resource.Internal wrappedResource
	Resource adapter
	String expectedMt
	String expectedLang
	URI melangeUri
	DozerLoader loader = new DozerLoader

	new(URI uri) {
		// FIXME: Retrieve the currently-used one
		val rs = new ResourceSetImpl
		val query = uri.query
		val SEPARATOR = "&|;"
		val pairs = query.split(SEPARATOR)
		
		expectedMt = pairs.findFirst[startsWith("mt=")]?.substring(3)
		expectedLang = pairs.findFirst[startsWith("lang=")]?.substring(5)

		melangeUri = uri
		wrappedResource = rs.getResource(MelangeResourceUtils.melangeToFallbackURI(uri), true) as Resource.Internal
	}

	def Resource getWrappedResource() {
		return wrappedResource
	}

	override getContents() throws RuntimeException {
		val objs = wrappedResource.getContents()
		if (objs.empty || (expectedMt == null && expectedLang == null))
			return objs
		
		// 1 - Convert Language to Language 
		var Resource resource = wrappedResource
		if (expectedLang !== null) {
			resource = resource.adaptResourceToLang(expectedLang)
		}
			
		// 2 - Adapt Language to ModelType
		if (expectedMt !== null) {
			resource = resource.adaptResourceToMT(expectedMt)
			adapter = resource
		}
		
		return resource.contents
	}

	override getAllContents() {
		return
			new AbstractTreeIterator<EObject>(this, false) {
				override getChildren(Object object) {
					return
						if (object instanceof Resource)
							object.contents.iterator
						else if (object instanceof EObject)
							object.eContents.iterator
				}
			}
	}

	override getEObject(String uriFragment) {
		return adapter.getEObject(uriFragment)
	}

	override getURIFragment(EObject o) {
		return
			if (o instanceof EObjectAdapter<?>)
				wrappedResource.getURIFragment(o.adaptee)
			else null
	}

	override getURI() {
		return melangeUri
	}
	
	/**
	 * Return a ResourceAdapter exposing {@link modelType} interfaces and
	 * delegating to {@link adaptedResource} 
	 */
	private def Resource adaptResourceToMT(Resource adaptedResource, String modelType){
		val actualLanguage = adaptedResource.language
		
		val adapterCls = actualLanguage.getAdapterFor(modelType)
		if (adapterCls !== null) {
			try {
				return adapterCls.newInstance => [
					adaptee = adaptedResource
					parent = this
				]
			} catch (InstantiationException e) {
				throw new MelangeResourceException('''Cannot instantiate adapter type «adapterCls»''', e)
			} catch (IllegalAccessException e) {
				throw new MelangeResourceException('''Cannot access adapter type «adapterCls»''', e)
			}
		}

		throw new MelangeResourceException('''No adapter class registered for <«actualLanguage.identifier», «modelType»>''')
	}
	
	/**
	 * Return a resource in the namespace of {@link language}
	 */
	private def Resource adaptResourceToLang(Resource adaptedResource, String language){
		val actualLanguage = adaptedResource.language
		val expectedLanguage = MelangeRegistry.INSTANCE.getLanguageByIdentifier(language)

		if (expectedLanguage === null)
			throw new MelangeResourceException("Cannot find a registered language with URI " + language)

		val actualMt = MelangeRegistry.INSTANCE.getModelTypeByIdentifier(actualLanguage.exactType)
		val expectedMt = MelangeRegistry.INSTANCE.getModelTypeByIdentifier(expectedLanguage.exactType)

		if (actualMt.identifier == expectedMt.identifier) {
			// Nothing to do
			return adaptedResource
		}
		else if (actualMt.superTypes.contains(expectedMt.identifier)) {
			// Upcast
			return adaptedResource
		}
		else if (expectedMt.superTypes.contains(actualMt.identifier)) {
			// Downcast
			val actualPkg = EPackage.Registry.INSTANCE.getEPackage(actualLanguage.uri)
			val expectedPkg = EPackage.Registry.INSTANCE.getEPackage(expectedLanguage.uri)
			loader.initialize(actualPkg, expectedPkg)
			return loader.loadBaseAsExtended(adaptedResource, expectedPkg)
		}
		else
			// No typing hierarchy found
			throw new MelangeResourceException('''«actualMt.identifier» cannot be transtyped to «expectedMt.identifier»''')
	}
	
	private def LanguageDescriptor getLanguage(Resource resource){
		val objs = resource.getContents()

		val actualPkgUri = objs.head.eClass.EPackage.nsURI
		val actualLanguage = MelangeRegistry.INSTANCE.getLanguageByUri(actualPkgUri)

		if (actualLanguage === null)
			throw new MelangeResourceException("Cannot find a registered language with URI " + actualPkgUri)
			
		return actualLanguage
	}
}
