package fr.inria.diverse.melange.ui

import fr.inria.diverse.melange.ui.hyperlink.MelangeHyperlinkHelper
import fr.inria.diverse.melange.ui.internal.MelangeActivator
import fr.inria.diverse.melange.ui.preferences.MelangePreferencePage
import org.eclipse.core.runtime.IStatus
import org.eclipse.core.runtime.Status
import org.eclipse.ui.plugin.AbstractUIPlugin
import org.eclipse.xtext.ui.editor.hyperlinking.IHyperlinkHelper
import org.eclipse.xtext.ui.editor.preferences.LanguageRootPreferencePage
import fr.inria.diverse.melange.ui.editor.MelangeDocumentProvider

class MelangeUiModule extends AbstractMelangeUiModule
{
	new(AbstractUIPlugin plugin) {
		super(plugin)
	}

	def Class<? extends LanguageRootPreferencePage> bindLanguageRootPreferencePage() {
	    return typeof(MelangePreferencePage)
	}
	
	override Class<? extends IHyperlinkHelper> bindIHyperlinkHelper() {
	    return typeof(MelangeHyperlinkHelper)
	}

	def static void logErrorMessage(String message, Throwable e) {
		MelangeActivator.instance.log.log(
			new Status(
				IStatus::ERROR,
				MelangeActivator.instance.bundle.symbolicName,
				IStatus::ERROR, message,
				e
			)
		)
	}
	
	override Class<? extends org.eclipse.xtext.ui.editor.model.XtextDocumentProvider> bindXtextDocumentProvider() {
		return typeof(MelangeDocumentProvider)
	}
}
