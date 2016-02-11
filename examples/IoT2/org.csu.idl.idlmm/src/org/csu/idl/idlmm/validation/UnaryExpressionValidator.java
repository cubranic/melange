/**
 *
 * $Id$
 */
package org.csu.idl.idlmm.validation;

import org.csu.idl.idlmm.Expression;

/**
 * A sample validator interface for {@link org.csu.idl.idlmm.UnaryExpression}.
 * This doesn't really do anything, and it's not a real EMF artifact.
 * It was generated by the org.eclipse.emf.examples.generator.validator plug-in to illustrate how EMF's code generator can be extended.
 * This can be disabled with -vmargs -Dorg.eclipse.emf.examples.generator.validator=false.
 */
public interface UnaryExpressionValidator {
	boolean validate();

	boolean validateExpression(Expression value);
	boolean validateOperator(String value);
}