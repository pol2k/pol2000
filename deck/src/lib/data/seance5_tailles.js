/* Généré par outils/seance5_tailles.R. Source : NHANES (États-Unis, 2009 à 2012), paquet R
   NHANES, adultes de 20 ans et plus, une ligne par personne, taille en cm. Aucune valeur ici
   n'est écrite à la main. */

/* Les adultes : n, moyenne, écart type, extrêmes, et l'histogramme en tranches de 2 cm, [a, a + 2). */
export const POPULATION = {"n":4613,"moyenne":168.266637762844,"ecartType":10.1595766726863,"min":134.5,"max":200.4,"bornes":[134,136,138,140,142,144,146,148,150,152,154,156,158,160,162,164,166,168,170,172,174,176,178,180,182,184,186,188,190,192,194,196,198,200,202],"effectifs":[1,1,2,3,11,25,39,67,77,133,181,228,244,303,306,325,329,347,306,300,287,254,225,193,133,105,73,50,31,15,12,2,4,1]};
/* Six adultes tirés au hasard (set.seed(5)) : leur taille. */
export const PERSONNES = [150.5,182.9,166.1,169.3,174.2,161.9];
/* Une classe de 50 adultes tirés au hasard (set.seed(50)) : les 50 tailles et leur moyenne. */
export const CLASSE = {"n":50,"tailles":[157.5,150.6,170.6,160.2,175.8,169.8,180.6,168.2,154.3,167.4,178.8,174.4,154.1,166.4,175.2,170.6,185.3,171,192.6,170.6,161.8,146.3,168.1,160.9,175.7,170.2,163.1,160,185.8,150.2,149,155.8,177.1,150.6,169.4,155.6,168,163.9,166.7,165.2,164.7,180.2,167.7,180.9,179.3,171.3,155.7,175.5,180.1,163.3],"moyenne":167.522};
/* 1 000 classes de 50 (set.seed(55)) : leurs moyennes en tranches de 0,5 cm, leur écart type. */
export const CLASSES = {"nombre":1000,"n":50,"moyenne":168.25191,"ecartType":1.39497114392822,"min":164.31,"max":172.864,"bornes":[164,164.5,165,165.5,166,166.5,167,167.5,168,168.5,169,169.5,170,170.5,171,171.5,172,172.5,173],"effectifs":[2,4,22,27,48,89,109,122,143,136,98,88,63,28,15,3,2,1]};
