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
		// ex {question : "9 - 3 = ?", answer : 6}
		return switch(op)
		{
			case PLUS: plus(diff);
			case MINUS: minus(diff);
			case MULTIPLY: mult(diff);
			case DIVIDE: divide(diff);
		}
	}

	public static function rand(top : UInt) : Int
	{
		// generate random numbers
		return ceil(random() * top);
	}

	private static function plus(diff : DIFFICULTY) : MathProblem
	{
		var t = switch(diff)
		{
			case EASY: 10;
			case MEDIUM: 20;
			case HARD: 30;
		}

		var a = rand(t);
		var b = rand(t);

		return {question : a + " + " + b, answer : a + b};
	}

	private static function minus(diff : DIFFICULTY) : MathProblem
	{
		var t = switch(diff)
		{
			case EASY: 10;
			case MEDIUM: 20;
			case HARD: 30;
		}

		var a = rand(t);
		var b = rand(t);

		//for simplicity, no negatives ever (might change)
		while(b > a) b = rand(t);
		return {question : a + " - " + b, answer : a - b};
	}

	private static function mult(diff : DIFFICULTY) : MathProblem
	{
		var t = switch(diff)
		{
			case EASY: 5;
			case MEDIUM: 8;
			case HARD: 12;
		}

		var a = rand(t);
		var b = rand(t);
		return {question : a + " x " + b, answer : Std.int(a * b)};
	}

	private static function divide(diff : DIFFICULTY) : MathProblem
	{
		var t = switch(diff)
		{
			case EASY: 5;
			case MEDIUM: 8;
			case HARD: 12;
		}

		var a = rand(t);
		var b = rand(t);

		//ensure answer isn't a fraction
		while(a % b != 0) b = rand(t);
		return {question : a + " / " + b, answer : Std.int(a/b)};
	}
}