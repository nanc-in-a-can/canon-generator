/*
* @title Arrow Canon
* @author Iván Naranjo
* @website www.ivan-naranjo.com
* @email naranjoivan@gmail.com
*/

/*
I initially departed from a temperate collection of pitches with a range of almost 6 octaves. I chose to normalize it in order to get a distinct harmony, while having the same identity (same set of propotions). These pitches, apart from being normalized, are scrambled so that each time the piece begins with a different motive. The generating principle for the rest of the pitch collections is a fractal one, taken only to its first iteration. The motive and proportions are mapped on each of the possible intervals between any two pitches in the original collection. They are played in order and then mirrored. This creates series of arrow-like shapes constantly ascending, and then descending and in the opposite direction.

Inicialmente comencé con una colección de alturas temperadas con un rango de casi seis octavas, que decidí normalizar a un rango menor para obtener una armonía inicial más interesante, que conserva las mismas proporciones entre sus elementos. Estas alturas, además de ser normalizadas, son re-ordenadas cada vez que se evalúa el siguiente código, de manera que cada vez, el motivo generador es uno distinto. El principio generador del resto de las alturas es de naturaleza fractal, llevado únicamente a una primera generación. El motivo original es mapeado a los rangos de cada uno de los intervalos posibles entre dos alturas cualesquiera de la colección original. Estas son tocadas en orden y después en espejo. Las series generan formas similares a flechas, y el rango asciende con cada iteración, hasta llegar al eje de simetría, cuando comienza un descenso gradual.
*/


(
//PITCHES (midi values)
var f1 = [25, 37, 48, 64, 75, 93, 107].normalize(30, 107).trunc(0.01);// [ 30, 41.26, 51.59, 66.62, 76.95, 93.85, 107 ]
var f1A = f1.scramble;
var f2 = f1A.normalize(f1[0], f1[5]);
var f3 = f1A.normalize(f1[0], f1[4]);
var f4 = f1A.normalize(f1[0], f1[3]);
var f5 = f1A.normalize(f1[0], f1[2]);
var f6 = f1A.normalize(f1[0], f1[1]);
var f7 = f1A.normalize(f1[1], f1[6]);
var f8 = f1A.normalize(f1[1], f1[5]);
var f9 = f1A.normalize(f1[1], f1[4]);
var f10 = f1A.normalize(f1[1], f1[3]);
var f11 = f1A.normalize(f1[1], f1[2]);
var f12 = f1A.normalize(f1[2], f1[6]);
var f13 = f1A.normalize(f1[2], f1[5]);
var f14 = f1A.normalize(f1[2], f1[4]);
var f15 = f1A.normalize(f1[2], f1[3]);
var f16 = f1A.normalize(f1[3], f1[6]);
var f17 = f1A.normalize(f1[3], f1[5]);
var f18 = f1A.normalize(f1[3], f1[4]);
var f19 = f1A.normalize(f1[4], f1[6]);
var f20 = f1A.normalize(f1[4], f1[5]);
var f21 = f1A.normalize(f1[5], f1[6]);

var ff = (f1A++f2++f3++f4++f5++f6++f7++f8++f9++f10++f11++f12++f13++f14++f15++f16++f17++f18++f19++f20++f21).trunc(0.01).mirror;

//DURATIONS
//the durations collection uses the intervals between the ascending values of the original pitch collection, and it is subjected to an analog generating process. However, the order of the resulting collections does not follow the order of generation. It was intentionally scarmbled to obtain the desired densities in the desired moments.
//La colección de duraciones usa los intervalos entre los valores, en orden ascendente, de la colección de alturas original, y es sometido a un proceso generativo análogo al de las alturas. Sin embargo, el orden de las colecciones, no sigue el orden generativo. Ha sido intencionalmente re-ordenado para lograr la sucesión de densidades deseadas.

var d1 = [12, 11, 16, 11, 18, 14, 15]*(1/16); // d1.sum; //6.0625
var d2 = d1*5.125/6.0625;
var d3 = d1*4.25/6.0625;
var d4 = d1*3.125/6.0625;
var d5 = d1*2.4375/6.0625;
var d6 = d1*1.4375/6.0625;
var d7 = d1*5.3125/6.0625;
var d8 = d1*4.375/6.0625;
var d9 = d1*3.5/6.0625;
var d10 = d1*2.375/6.0625;
var d11 = d1*1.6875/6.0625;
var d12 = d1*4.625/6.0625;
var d13 = d1*3.6875/6.0625;
var d14 = d1*2.8125/6.0625;
var d15= d1*1.6875/6.0625;
var d16= d1*3.625/6.0625;
var d17 = d1*2.6875/6.0625;
var d18 = d1*1.8125/6.0625;
var d19 = d1*2.9375/6.0625;
var d20 = d1*2/6.0625;
var d21= d1*1.8125/6.0625;

var dd = (d8++d15++d14++d1++d2++d3++d4++d20++d5++d11++d6++d7++d16++d9++d19++d10++d12++d13++d17++d18++d21).reverse.mirror;


// Even though each voice is symmetrical, the convergence point is displaced until after the axis of symmetry. This generates a more unstable balance between the voices and results in interesting conglomerates from which new motives, textures and forces emerge.

// Aunque la secuencia de cada voz es simétrica, el punto de convergencia ha sido desplazado más allá del eje de simetría. Esto genera un balance más inestable entre las voces y resulta en aglomeraciones interesantes, de las cuales emergen nuevos motivos, texturas y fuerzas.
var melody = (
  cp: 199,
    melody: ~makeMelody.(dd, ff),
	// Tempi and transpositions are also derived from the original collection of pitches.
	// Los tempos y transposiciones también son derivados de las proporciones en la colección de alturas original
    voices: [
        (tempo: 140, transp: 0),
        (tempo: 140*37/25, transp: 2.5),
        (tempo: 140*48/37, transp: 3.7),
        (tempo: 140*4/3, transp: 4.8),
        (tempo: 140*75/64, transp: 6.4),
        (tempo: 140*93/75, transp: 7.5),
        (tempo: 140*107/93, transp: 9.3),
    ]
);


var canon = ~convCanon.(melody);

var playable = canon.canon
	.collect(~instrument.([\blipo]));

~presets.naranjo.arrowCanon = (
	canon: canon,
	visualize: {~visualize.(canon)},
	play: {playable.do(_.play)}
);


)

// ~naranjo.play

// ~visualize.(~naranjo.canon)