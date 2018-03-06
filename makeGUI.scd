

//  GUI

// tempos, transposiciones, melodía

(
var width=500, height=300, button_start, voices, voicesStTx, transp, transpStTx, popUp, popUpStTx, cp, cpStTx;
v= Window("Nanc in a Can(on)", Rect(100,100, width, height));

button_start= Button(v, Rect(425,5, 50,30));
button_start.states = ([["Start",Color.black, Color.green],["Stop",Color.black, Color.red]]);

voices= TextField(v, Rect(120, 15, 300, 20));
voices.valueAction_("90, 100, 110, 120");
voices.action = {| field | field.value.asString.split($,).postln; field.value.asString.split($,).size.postln;/*aqui va la action del tempo*/};

voicesStTx= StaticText(v, Rect(10, 15, 80, 20));
voicesStTx.string= "Tempo of voices";

transp= TextField(v, Rect(120, 40, 300, 20));
transp.valueAction_("0, 8, 12, -12");
transp.action = {| field | field.value.asString.split($,).postln; field.value.asString.split($,).size.postln;/*aqui va la action del tempo*/};

transpStTx= StaticText(v, Rect(10, 40, 80, 20));
transpStTx.string= "Transposition";


cp= NumberBox(v, Rect(120, 65, 100, 20));
cp.valueAction_(300);
cp.action = {| field | field.postln; /*aqui va el cambio de convPoint*/};

cpStTx= StaticText(v, Rect(10, 65, 100, 20));
cpStTx.string= "Convergence Point";


popUp= PopUpMenu(v, Rect(120, 170, 300, 20));
popUp.items = ~melodyMaker.keys.asArray;

popUpStTx= StaticText(v, Rect(10, 170, 80, 20));
popUpStTx.string= "choose Melody";

v.front;
CmdPeriod.doOnce({if(v.isClosed.not, {v.close})});
)









(
w = Window.new.front;
a = TextField(w, Rect(10, 10, 150, 20));
a.string = "hi there";
a.action = {arg field; field.value.postln; };
)

// does not do the action
a.value = "yo";
a.string = "oy";

a.valueAction_("this is not a pipe"); //does the action, if the value has changed
a.doAction; //evaluates the action with the content of the text field as an argument

a.background_(Color.grey);
a.stringColor_(Color.white);
a.align_(\center);