module rascal::hundred1Companies::Check

import ParseTree;

import rascal::hundred1Companies::Grammar;
import rascal::hundred1Companies::AST;
import rascal::hundred1Companies::BuildAST;
import rascal::hundred1Companies::Verify;

public S_Companies checkCompanies(S_Companies sc) {
	c = buildAST(sc);
	msgs = verify(c);
	return sc[@messages = msgs];
}
