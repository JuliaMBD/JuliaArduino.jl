#=
//www.elegoo.com
//2016.12.08

int buzzer = 12;//the pin of the active buzzer
void setup()
{
 pinMode(buzzer,OUTPUT);//initialize the buzzer pin as an output
}
void loop()
{
 unsigned char i;
 while(1)
 {
   //output an frequency
   for(i=0;i<80;i++)
   {
    digitalWrite(buzzer,HIGH);
    delay(1);//wait for 1ms
    digitalWrite(buzzer,LOW);
    delay(1);//wait for 1ms
    }
    //output another frequency
     for(i=0;i<100;i++)
      {
        digitalWrite(buzzer,HIGH);
        delay(2);//wait for 2ms
        digitalWrite(buzzer,LOW);
        delay(2);//wait for 2ms
      }
  }
} 
=#

module Test
	using JuliaArduino
	@config "../atmega328p.json"

    const BUZZER = D12
    
    function main()::Int8
        pinMode(BUZZER, OUTPUT)

        while true
            for _ = 1:800
                digitalWrite(BUZZER, HIGH)
                @delay_ms(1)
                digitalWrite(BUZZER, LOW)
                @delay_ms(1)
            end
            for _ = 1:1000
                digitalWrite(BUZZER, HIGH)
                @delay_ms(2)
                digitalWrite(BUZZER, LOW)
                @delay_ms(2)
            end
        end
        return 0
    end
end

@testset "buzzer" begin
	target = Arduino(Test.MMCU, "")
	obj = build(Test.main, Tuple{}, target=target)
	write("Test_main.o", obj)
end
