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
	ALGEBRA;
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
			case ALGEBRA: algebra(diff);
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
			case EASY: {bottom : 1, top : 6};
			case MEDIUM: {bottom : 2, top : 10};
			case HARD: {bottom : 10, top : 25};
		}

		var a = rand(t);
		var b = rand(t);

		return {question : a + " + " + b, answer : a + b};
	}

	private static function minus(diff : DIFFICULTY) : MathProblem
	{
		var t = switch(diff)
		{
			case EASY: {bottom : 2, top : 11};
			case MEDIUM: {bottom : 5, top : 20};
			case HARD: {bottom : 8, top : 25};
		}

		var a = rand(t);
		var b = rand(t);

		//for simplicity, no negatives ever (might change)
		while ((b > a) || (b == a)) { b = rand(t); a = rand(t); }
		return {question : a + " - " + b, answer : a - b};
	}

	private static function mult(diff : DIFFICULTY) : MathProblem
	{
		var t = switch(diff)
		{
			case EASY: {bottom : 2, top : 7};
			case MEDIUM: {bottom : 3, top : 9};
			case HARD: {bottom : 4, top : 12};
		}

		var a = rand(t);
		var b = rand(t);
		return {question : a + " x " + b, answer : Std.int(a * b)};
	}

	private static function divide(diff : DIFFICULTY) : MathProblem
	{
		var t = switch(diff)
		{
			case EASY: {bottom : 2, top : 35};
			case MEDIUM: {bottom : 4, top : 40};
			case HARD: {bottom : 6, top : 60};
		}

		var a = rand(t);
		var b = rand(t);

		//ensure answer isn't a fraction
		while ((a % b != 0) || (a == b) || (b > 12)) { b = rand(t); a = rand(t); }
		return {question : a + " / " + b, answer : Std.int(a/b)};
	}
	
	
	
	
	private static function algebra(diff : DIFFICULTY): MathProblem
	{
		var t = switch(diff)
		{
			case EASY: {bottom : 1, top : 35};
			case MEDIUM: {bottom : 4, top : 40};
			case HARD: {bottom : 6, top : 60};
		}
		var a = rand(t);
		var b = rand(t);
		var c = rand(t);
		while (((c - b) % a != 0) || (a == b) || (b == c) || (b > c)) { b = rand(t); a = rand(t); c = rand(t); }
		return {question : a + "x + " + b + " = " + c, answer : Std.int((c - b) / a)};
	}
}