#include <avr/io.h>
#include <avr/interrupt.h>  //割り込みを使用するため

//ISR-main間で使う変数count
//コンパイラは、この変数を最適化しない
volatile unsigned char count;

//割り込み関数
ISR(TIMER0_OVF_vect) //timer0でオーバーフローが起きたとき
{
  count++;
}

int main()
{
  //ここで割り込みを行うためにレジスタの設定をする
  
  //cil();  //割り込み禁止
  sei();    //割り込み許可
  while(1){
    //普段の処理
  }
  
  return 0;
}