
public class Protocol3Server {
	public static void main(String[] args)
	{
		float one = 1;
		float two = 3;
		float three = 3;
		float four = 4;
		String panda = "shake it like a panda bear";
		String howMany = "How many panda bears?";
		float avg = 0;
		avg = one * two + three / four - 2;
		System.out.println(howMany + avg);
		if (one + two == 4)
		{
			System.out.println(panda);
		}
		else
		{
			System.out.println("hello from the other side, I must have coded a thousand times");
		}
		if (one + two == 3)
		{
			System.out.println("Hello from my Chiquita Phone");
		}
		System.out.println("token");
	}

}
