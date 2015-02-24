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
typedef Range = {bottom : Int, top : Int}
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

	public static function rand(range : Range) : Int
	{
		// generate random numbers
		return ceil(random() * (range.top-range.bottom)+range.bottom);
	}

	private static function plus(diff : DIFFICULTY) : MathProblem
	{
		var t = switch(diff)
		{
			case EASY: {bottom : 1, top : 11};
			case MEDIUM: {bottom : 10, top : 26};
			case HARD: {bottom : 20, top : 51};
		}

		var a = rand(t);
		var b = rand(t);

		return {question : a + " + " + b, answer : a + b};
	}

	private static function minus(diff : DIFFICULTY) : MathProblem
	{
		var t = switch(diff)
		{
			case EASY: {bottom : 1, top : 11};
			case MEDIUM: {bottom : 10, top : 26};
			case HARD: {bottom : 20, top : 51};
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
			case EASY: {bottom : 1, top : 5};
			case MEDIUM: {bottom : 4, top : 8};
			case HARD: {bottom : 5, top : 13};
		}

		var a = rand(t);
		var b = rand(t);
		return {question : a + " x " + b, answer : Std.int(a * b)};
	}

	private static function divide(diff : DIFFICULTY) : MathProblem
	{
		var t = switch(diff)
		{
			case EASY: {bottom : 1, top : 5};
			case MEDIUM: {bottom : 4, top : 8};
			case HARD: {bottom : 5, top : 13};
		}

		var a = rand(t);
		var b = rand(t);

		//ensure answer isn't a fraction
		while(a % b != 0) b = rand(t);
		return {question : a + " / " + b, answer : Std.int(a/b)};
	}
}