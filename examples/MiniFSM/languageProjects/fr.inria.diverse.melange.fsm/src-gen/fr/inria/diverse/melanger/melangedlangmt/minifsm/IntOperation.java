/**
 */
package fr.inria.diverse.melanger.melangedlangmt.minifsm;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Int Operation</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.inria.diverse.melanger.melangedlangmt.minifsm.IntOperation#getRight <em>Right</em>}</li>
 *   <li>{@link fr.inria.diverse.melanger.melangedlangmt.minifsm.IntOperation#getLeft <em>Left</em>}</li>
 * </ul>
 *
 * @see fr.inria.diverse.melanger.melangedlangmt.minifsm.MinifsmPackage#getIntOperation()
 * @model
 * @generated
 */
public interface IntOperation extends IntExpression {
	/**
	 * Returns the value of the '<em><b>Right</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Right</em>' containment reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Right</em>' containment reference.
	 * @see #setRight(IntExpression)
	 * @see fr.inria.diverse.melanger.melangedlangmt.minifsm.MinifsmPackage#getIntOperation_Right()
	 * @model containment="true" required="true"
	 * @generated
	 */
	IntExpression getRight();

	/**
	 * Sets the value of the '{@link fr.inria.diverse.melanger.melangedlangmt.minifsm.IntOperation#getRight <em>Right</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Right</em>' containment reference.
	 * @see #getRight()
	 * @generated
	 */
	void setRight(IntExpression value);

	/**
	 * Returns the value of the '<em><b>Left</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Left</em>' containment reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Left</em>' containment reference.
	 * @see #setLeft(IntExpression)
	 * @see fr.inria.diverse.melanger.melangedlangmt.minifsm.MinifsmPackage#getIntOperation_Left()
	 * @model containment="true" required="true"
	 * @generated
	 */
	IntExpression getLeft();

	/**
	 * Sets the value of the '{@link fr.inria.diverse.melanger.melangedlangmt.minifsm.IntOperation#getLeft <em>Left</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Left</em>' containment reference.
	 * @see #getLeft()
	 * @generated
	 */
	void setLeft(IntExpression value);

} // IntOperation
