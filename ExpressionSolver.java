import java.util.Stack;

public class ExpressionSolver {
    public static double evaluateExpression(String expression) {
        char[] tokens = expression.toCharArray();

        // Stack for numbers
        Stack<Double> values = new Stack<>();

        // Stack for operators
        Stack<Character> operators = new Stack<>();

        for (int i = 0; i < tokens.length; i++) {
            // Ignore whitespace
            if (tokens[i] == ' ')
                continue;

            // If the current token is a number, extract the full number
            if (Character.isDigit(tokens[i])) {
                StringBuilder sb = new StringBuilder();
                while (i < tokens.length && (Character.isDigit(tokens[i]) || tokens[i] == '.')) {
                    sb.append(tokens[i]);
                    i++;
                }
                values.push(Double.parseDouble(sb.toString()));
                i--;
            }
            // If the current token is an opening parenthesis, push it to the operators stack
            else if (tokens[i] == '(')
                operators.push(tokens[i]);
            // If the current token is a closing parenthesis, solve the sub-expression
            else if (tokens[i] == ')') {
                while (operators.peek() != '(')
                    values.push(applyOperator(operators.pop(), values.pop(), values.pop()));
                operators.pop();
            }
            // If the current token is an operator
            else if (tokens[i] == '+' || tokens[i] == '-' || tokens[i] == '*' || tokens[i] == '/') {
                // While the top of the operators stack has higher or equal precedence, apply the operator
                while (!operators.empty() && hasPrecedence(tokens[i], operators.peek()))
                    values.push(applyOperator(operators.pop(), values.pop(), values.pop()));

                operators.push(tokens[i]);
            }
        }

        // Apply remaining operators to the remaining values
        while (!operators.empty())
            values.push(applyOperator(operators.pop(), values.pop(), values.pop()));

        // The final result will be at the top of the values stack
        return values.pop();
    }

    // Check if the operator1 has higher or equal precedence than operator2
    private static boolean hasPrecedence(char operator1, char operator2) {
        if (operator2 == '(' || operator2 == ')')
            return false;
        return (operator1 != '*' && operator1 != '/') || (operator2 != '+' && operator2 != '-');
    }

    // Apply the operator to the operands
    private static double applyOperator(char operator, double b, double a) {
        switch (operator) {
            case '+':
                return a + b;
            case '-':
                return a - b;
            case '*':
                return a * b;
            case '/':
                if (b == 0)
                    throw new UnsupportedOperationException("Cannot divide by zero");
                return a / b;
        }
        return 0;
    }
}
