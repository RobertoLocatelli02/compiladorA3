grammar Pele;

@header {
import org.antlr.v4.runtime.*;
import java.util.*;
}

// Ações semânticas
@members {
  Pele pele = new Pele();
}

// Definição das regras sintáticas
program: start statement* end {pele.writeCode();};

start: 'inizio' {pele.printInicio();};

statement:
	assignment
	| variableDeclaration
	| ifStatement
	| loopStatement
	| scanfStatement
	| printStatement
	| incrementVariable
	| decrementVariable;

variableDeclaration: type=('int' | 'float' | 'string') id=ID '=' mathExpression
 ';' {pele.declararVariavel($id.getText(), $type.getText());};

assignment: id=ID '=' mathExpression ';' {pele.atribuirVariavel($id.getText());};

mathExpression: (value = INT {pele.adicionaBuffer($value.getText());} | value = DECIMAL {pele.adicionaBuffer($value.getText());} | value = STRING {pele.adicionaBuffer($value.getText());}) (value=OPMATH {pele.adicionaBuffer($value.getText());} (value = INT {pele.adicionaBuffer($value.getText());} | value = DECIMAL {pele.adicionaBuffer($value.getText());} | value = STRING {pele.adicionaBuffer($value.getText());}))*;

logicExpression: (value = INT | value = DECIMAL | value = STRING | id = ID {boolean declarado = pele.checkVariableDeclared($id.getText()); if (!declarado) {throw new IllegalArgumentException("Variável não declarada: " + $id.getText());}}) {pele.code+=$value != null ? $value.getText() : $id.getText();} op = OPREL {pele.code+=$op.getText();} (value = INT | value = DECIMAL | value = STRING) {pele.code+=$value.getText();};

incrementVariable: id = ID '++;' {pele.incrementaVariavel($id.getText());};

decrementVariable: id = ID '--;' {pele.decrementaVariavel($id.getText());};

end: 'fine' {pele.printFim();};

ifStatement: 'se' '(' {pele.code += "\nif(";} logicExpression ')' {pele.code += ")\n";} block ('altrimenti' {pele.code += "else\n";} block)?;

loopStatement: whileStatement | doWhileStatement ;

whileStatement: 'mentre' '(' {pele.code += "\nwhile(";} logicExpression ')'{pele.code += ")";} block;

doWhileStatement: 'fare' {pele.code += "\ndo";} block 'mentre' '(' {pele.code += "while(";} logicExpression ')' ';' {pele.code += ");";};

block: '{' {pele.printAC();} statement* '}' {pele.printFC();};

scanfStatement: 'leggere' '(' id = ID ',' question = STRING ')' ';' {pele.lerUserInput($id.getText(), $question.getText());};

printStatement:
	'scrivere' '(' (id = ID | str = STRING) ')' ';' {pele.printString($id != null ? $id.getText() : $str.getText());
		};

// Definição dos tokens léxicos
ID: [a-zA-Z][a-zA-Z0-9_]*;
INT: [0-9]+;
DECIMAL: [0-9]+ '.' [0-9]+;
STRING: '"' ~["\r\n]* '"';
OPREL: '>' | '<' | '>=' | '<=' | '==' | '!=';
WS: [ \t\r\n]+ -> skip;
OPMATH: '+' | '-' | '*' | '/';
AND: '&&';
OR: '||';