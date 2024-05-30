import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class Pele {

    String code = "";
    String buffer = "";
    Map<String, String> symbolTable = new HashMap<>();

    public Pele() {
        this.code = "";
        this.symbolTable = new HashMap<>();
    }
    
    protected void printString(String str) {
        code += "System.out.println(" + str + ");";
    }

    protected void printInicio() {
        code += "import java.util.Scanner;\n";
        code += "public class Output {\n";
        code += "public static void main(String[] args) {\n";
    }

    protected void printFim() {
        code += "}\n";
        code += "}\n";
    }

    protected void printAC(){
        code += "{\n";
    }

    protected void printFC(){
        code += "}\n";
    }

    protected void adicionaBuffer(String str) {
        buffer += str;
    }

    protected void limpaBuffer() {
        buffer = "";
    }

    protected void incrementaVariavel(String nome){
        boolean isdeclared = checkVariableDeclared(nome);
        
        if (!isdeclared) {
            throw new IllegalArgumentException("Variável não declarada: " + nome);
        }

        code+= nome + "++;\n";
    }

    protected void decrementaVariavel(String nome){
        boolean isdeclared = checkVariableDeclared(nome);
        
        if (!isdeclared) {
            throw new IllegalArgumentException("Variável não declarada: " + nome);
        }

        code+= nome + "--;\n";
    }

    protected void declararVariavel(String nome, String tipo) {
        boolean isdeclared = checkVariableDeclared(nome);

        if (isdeclared) {
            throw new IllegalArgumentException("Variável já declarada: " + nome);
        }

        String valor = null;

        if (tipo.equals("bool")) {
            tipo = "boolean";
        } else if (tipo.equals("string")) {
            tipo = "String";
            valor = this.buffer;
        } else if (tipo.equals("int")) {
            double result = ExpressionSolver.evaluateExpression(this.buffer);
            valor = String.valueOf((int) result);
        } else if (tipo.equals("float")) {
            double result = ExpressionSolver.evaluateExpression(this.buffer);
            valor = String.valueOf(result);
        } else {
            throw new IllegalArgumentException("Tipo de variável inválido: " + tipo);
        }

        if (valor != null) {
            boolean isValidType = checkVariableType(valor, tipo);
            if (!isValidType) {
                throw new IllegalArgumentException("Valor incompatível da variável: " + nome);
            }
        }

        this.symbolTable.put(nome, tipo);
        
        if (tipo.equals("bool")) {
            valor = getValidJavaBoolean(valor);
            tipo = "boolean";
        } else if (tipo.equals("float")) {
            tipo = "double";
        }

        code += tipo + " " + nome + " = " + valor + ";\n";
        this.limpaBuffer();
    }

    protected void atribuirVariavel(String nome) {
        boolean isdeclared = checkVariableDeclared(nome);

        if (!isdeclared) {
            throw new IllegalArgumentException("Variável não declarada: " + nome);
        }
        String tipo = this.symbolTable.get(nome);

        String valor = null;

        if (tipo.toLowerCase().equals("bool")) {
            tipo = "boolean";
        } else if (tipo.toLowerCase().equals("string")) {
            tipo = "String";
            valor = this.buffer;
        } else if (tipo.toLowerCase().equals("int")) {
            double result = ExpressionSolver.evaluateExpression(this.buffer);
            valor = String.valueOf((int) result);
        } else if (tipo.toLowerCase().equals("float")) {
            double result = ExpressionSolver.evaluateExpression(this.buffer);
            valor = String.valueOf(result);
        } else {
            throw new IllegalArgumentException("Tipo de variável inválido: " + tipo);
        }

        boolean isValidType = checkVariableType(valor, tipo);
        if (!isValidType) {
            throw new IllegalArgumentException("Valor incompatível da variável: " + nome);
        }

        // Adiciona a variavel no código
        if (tipo.equals("bool")) {
            valor = getValidJavaBoolean(valor);
        }
        code += nome + " = " + valor + ";\n";
        this.limpaBuffer();
    }

    private String getValidJavaBoolean(String value) {
        if (value.equals("verdadeiro")) {
            return "true";
        } else if (value.equals("falso")) {
            return "false";
        } else {
            return "false";
        }
    }

    private boolean checkVariableType(String valor, String tipo){
        if (tipo.toLowerCase().equals("int")) {
            try {
                Integer.parseInt(valor);
            } catch (NumberFormatException e) {
                return false;
            }
        } else if (tipo.toLowerCase().equals("float")) {
            try {
                Double.parseDouble(valor);
            } catch (NumberFormatException e) {
                return false;
            }
        } else if (tipo.toLowerCase().equals("string")) {
            return true;
        } else if (tipo.equals("bool")) {
            if (!valor.equals("verdadeiro") && !valor.equals("falso")) {
                return false;
            }
        } else {
            return false;
        }
        return true;
    }

    protected boolean checkVariableDeclared(String nome) {
        if (!this.symbolTable.containsKey(nome)) {
            return false;
        } else {
            return true;
        }
    }

    protected void lerUserInput(String id, String question){
        boolean isdeclared = checkVariableDeclared(id);

        if (!isdeclared) {
            throw new IllegalArgumentException("Variável não declarada: " + id);
        }

        String tipo = this.symbolTable.get(id);

        code += "Scanner userInput = new Scanner(System.in);\n";
        code += "System.out.println(" + question + ");\n";
        if (tipo.toLowerCase().equals("int")) {
            code += id + " = userInput.nextInt();\n";
        } else if (tipo.toLowerCase().equals("float")) {
            code += id + " = userInput.nextDouble();\n";
        } else if (tipo.toLowerCase().equals("string")) {
            code += id + " = userInput.nextLine();\n";
        } else if (tipo.toLowerCase().equals("bool")) {
            code += id + " = userInput.nextLine();\n";
        } else {
            throw new IllegalArgumentException("Tipo de variável inválido: " + tipo);
        }

        
        code += "userInput.close();\n";
    }

    public void writeCode() {
        try {
            FileWriter fileWriter = new FileWriter("Output.java");

            BufferedWriter bufferedWriter = new BufferedWriter(fileWriter);

            bufferedWriter.write(this.code);

            bufferedWriter.close();
        } catch (IOException ex) {
            System.out.println("Error writing to file '" + "Output.java" + "'");
        }

    }

    
    

}
