/**
 */
package fr.inria.diverse.iot2.iot2.iot2.impl;

import fr.inria.diverse.iot2.iot2.iot2.ExceptionDef;
import fr.inria.diverse.iot2.iot2.iot2.Field;
import fr.inria.diverse.iot2.iot2.iot2.Iot2Package;

import java.util.Collection;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

import org.eclipse.emf.ecore.util.EObjectContainmentEList;
import org.eclipse.emf.ecore.util.InternalEList;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Exception Def</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link fr.inria.diverse.iot2.iot2.iot2.impl.ExceptionDefImpl#getTypeCode <em>Type Code</em>}</li>
 *   <li>{@link fr.inria.diverse.iot2.iot2.iot2.impl.ExceptionDefImpl#getMembers <em>Members</em>}</li>
 * </ul>
 *
 * @generated
 */
public class ExceptionDefImpl extends ContainedImpl implements ExceptionDef {
	/**
	 * The default value of the '{@link #getTypeCode() <em>Type Code</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTypeCode()
	 * @generated
	 * @ordered
	 */
	protected static final String TYPE_CODE_EDEFAULT = null;

	/**
	 * The cached value of the '{@link #getTypeCode() <em>Type Code</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTypeCode()
	 * @generated
	 * @ordered
	 */
	protected String typeCode = TYPE_CODE_EDEFAULT;

	/**
	 * The cached value of the '{@link #getMembers() <em>Members</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getMembers()
	 * @generated
	 * @ordered
	 */
	protected EList<Field> members;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected ExceptionDefImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return Iot2Package.Literals.EXCEPTION_DEF;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public String getTypeCode() {
		return typeCode;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setTypeCode(String newTypeCode) {
		String oldTypeCode = typeCode;
		typeCode = newTypeCode;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, Iot2Package.EXCEPTION_DEF__TYPE_CODE, oldTypeCode, typeCode));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EList<Field> getMembers() {
		if (members == null) {
			members = new EObjectContainmentEList<Field>(Field.class, this, Iot2Package.EXCEPTION_DEF__MEMBERS);
		}
		return members;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case Iot2Package.EXCEPTION_DEF__MEMBERS:
				return ((InternalEList<?>)getMembers()).basicRemove(otherEnd, msgs);
		}
		return super.eInverseRemove(otherEnd, featureID, msgs);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case Iot2Package.EXCEPTION_DEF__TYPE_CODE:
				return getTypeCode();
			case Iot2Package.EXCEPTION_DEF__MEMBERS:
				return getMembers();
		}
		return super.eGet(featureID, resolve, coreType);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void eSet(int featureID, Object newValue) {
		switch (featureID) {
			case Iot2Package.EXCEPTION_DEF__TYPE_CODE:
				setTypeCode((String)newValue);
				return;
			case Iot2Package.EXCEPTION_DEF__MEMBERS:
				getMembers().clear();
				getMembers().addAll((Collection<? extends Field>)newValue);
				return;
		}
		super.eSet(featureID, newValue);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void eUnset(int featureID) {
		switch (featureID) {
			case Iot2Package.EXCEPTION_DEF__TYPE_CODE:
				setTypeCode(TYPE_CODE_EDEFAULT);
				return;
			case Iot2Package.EXCEPTION_DEF__MEMBERS:
				getMembers().clear();
				return;
		}
		super.eUnset(featureID);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public boolean eIsSet(int featureID) {
		switch (featureID) {
			case Iot2Package.EXCEPTION_DEF__TYPE_CODE:
				return TYPE_CODE_EDEFAULT == null ? typeCode != null : !TYPE_CODE_EDEFAULT.equals(typeCode);
			case Iot2Package.EXCEPTION_DEF__MEMBERS:
				return members != null && !members.isEmpty();
		}
		return super.eIsSet(featureID);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public String toString() {
		if (eIsProxy()) return super.toString();

		StringBuffer result = new StringBuffer(super.toString());
		result.append(" (typeCode: ");
		result.append(typeCode);
		result.append(')');
		return result.toString();
	}

} //ExceptionDefImpl
