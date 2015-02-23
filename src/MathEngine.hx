import starling.display.Sprite;
import starling.core.*;
import Math.*;

class MathEngine extends Sprite {
	
	var difficulty: String; // 'e' 'm' 'h'
	var top: Int;
	var a: Int; // the first number in the question.
	var b: Int; // the second number in the question.
	
	public function new()
	{
		super();
		
		
	}
	
	public function generateProblem(op:String, diff:String) : String {
		// op is the type of problem. ex. +, -, *, /
		// diff is the difficulty. Accepts 'e', 'm', 'h'
		var ans:Int = 0; // default... I don't like this but haxe complains otherwise
		difficulty = diff;
		var top:Int = 10; // default to easy	
		
		// do the correct operation on the numbers
		if (op == '+') { ans = plus(); }
		else if (op == '-') { ans = minus(); }
		else if (op == '*') { ans = mult(); }
		else if (op == '/') { ans = divide(); }
		
		var ques:String = a + op + b;
		// IMPORTANT: returns question, answer. so: "9-3, 6"
		return ques + ", " + ans;
	}
	
	private function plus() : Int { 
		// choose difficulty caps
		if (difficulty == 'e') { top = 10; }
		else if (difficulty == 'm') { top = 20; }
		else if (difficulty == 'h') { top = 30; }
		
		// generate random numbers
		a = ceil(random() * (top));
		b = ceil(random() * (top - a));
		
		return a + b; 
		
	}
	private function minus() : Int { 
		
		// choose difficulty caps
		if (difficulty == 'e') { top = 10; }
		else if (difficulty == 'm') { top = 20; }
		else if (difficulty == 'h') { top = 30; }
		
		// generate random numbers
		a = ceil(random() * (top));
		b = ceil(random() * (top - a));
		
		if (difficulty == 'e') {
			// don't make negative numbers if the difficulty is easy.
			if (a < b) {
				// swap the numbers so that it isn't negative.
				var low = a;
				a = b;
				b = low;
			}
		}
		return a - b; 
		
	}
	private function mult() : Int { 
		
		// choose difficulty caps
		if (difficulty == 'e') { top = 5; }
		else if (difficulty == 'm') { top = 10; }
		else if (difficulty == 'h') { top = 12; }
		
		// generate random numbers
		a = ceil(random() * (top));
		b = ceil(random() * top);

		return a * b; 
		
	}
	private function divide() : Int { 
		
		if (a < b) {
			// swap the numbers so that division isn't a fraction.
			var low = a;
			a = b;
			b = low;
		}
		
		// multiply and then re-work for a division problem.
		var multAns = mult();
		
		var bottom = a;
		a = multAns;
		
		var divAnswer = b;
		b = bottom;
		
		return divAnswer;
	}
}