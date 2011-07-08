@license{
  Copyright (c) 2009-2011 CWI
  All rights reserved. This program and the accompanying materials
  are made available under the terms of the Eclipse Public License v1.0
  which accompanies this distribution, and is available at
  http://www.eclipse.org/legal/epl-v10.html
}
@contributor{Mark Hills - Mark.Hills@cwi.nl (CWI)}
module rascal::hundred1Companies::Language

import ParseTree;
import util::IDE;

import rascal::hundred1Companies::Grammar;

public void register101() {
  	registerLanguage("101Companies", "hc", Tree (str x, loc l) {
    	return parse(#Grammar::S_Companies, x, l);
  	});
}   
