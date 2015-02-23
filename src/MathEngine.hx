import starling.display.Sprite;
import starling.core.*;
import Math.*;

enum DIFFICULTY
{
	EASY;
	MEDIUM;
	HARD;
}

enum OPERATION
{
	PLUS;
	MINUS;
	MULTIPLY;
	DIVIDE;
}

typedef MathProblem = {question : String, answer : Int}
class MathEngine
{
	public static function generateProblem(op:OPERATION, diff:DIFFICULTY) : MathProblem
	{
		// choose difficulty caps
		var top = switch(diff)
		{
			case EASY: 10;
			case MEDIUM: 20;
			case HARD: 30;
		}

		// ex {question : "9 minus 3 = ?", answer : 6}
		return switch(op)
		{
			case PLUS: plus(top);
			case MINUS: minus(top);
			case MULTIPLY: mult(top);
			case DIVIDE: divide(top);
		}
	}

	private static function plus(top : UInt) : MathProblem
	{
		// generate random numbers
		var a = ceil(random() * (top));
		var b = ceil(random() * (top - a));

		return {question : a + " plus " + b, answer : a + b};
	}

	private static function minus(top : UInt) : MathProblem
	{
		// generate random numbers
		var a = ceil(random() * (top));
		var b = ceil(random() * (top - a));

		if (top <= 10)
		{
			// don't make negative numbers if the difficulty is easy.
			while(a < b) b = ceil(random() * (top));
		}

		return {question : a + " minus " + b, answer : a - b};
	}

	private static function mult(top : UInt) : MathProblem
	{
		// generate random numbers
		var a = ceil(random() * (top));
		var b = ceil(random() * top);

		return {question : a + " times " + b, answer : Std.int(a * b)};
	}

	private static function divide(top : UInt) : MathProblem
	{
		// generate random numbers
		var a = ceil(random() * (top));
		var b = ceil(random() * top);

		//ensure answer isn't a fraction
		while(a % b != 0) b = ceil(random() * top);

		return {question : a + " divided by " + b, answer : Std.int(a/b)};
	}
}