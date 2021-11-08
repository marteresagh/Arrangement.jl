# Original
Input -> V,EV (vertici e spigoli)
Indexing -> indici di incidenza tra spigoli
Decomposition -> intersezioni tra spigoli (EVITARE intersezioni simmetriche)
Congruence -> eliminazione di punti doppi (e di conseguenza evitare di fare questo merge)
Connection -> calcolo componenti biconnesse (con la libreria sui grafi è inutile questa fase)
Bases -> base di cicli per ogni componente (calcolo con la nuova libreria molto efficiente)
Boundaries -> estrazione del bordo della componente (inutile con la nuova procedura)
Containment -> relazione di contenimento tra componenti (grafo non tra componenti ma tra cicli)
Reduction -> riduzione transitiva della relazione tra componenti (riduzione da fare per il calcolodell'albero di contenimento)
Adjoining -> generazione delle celle con i suoi buchi (2 strade o mantengo una struttura che mi indica chi sono le outer cell e gli holes
                o continuo con questa strada ma devo andare a creare la matrice di bordo_2 con segno: cella piena antiorario e cella bucata orario)
Assembling -> unione dell'intero modello (triangolazione per la visualizzazione)
Output -> V,EV,FV (vertici, spigoli e facce)


# My version
Input -> V,EV
Planar -> creazione del grafo planare (input-> V,EV, output-> V,EV)
Bases -> calcolo della base di cicli suddiviso per componente (input-> V,EV, output-> base di cicli per componente)
containment -> grafo ridotto di contenimento tra cicli per componente (input-> V,EV, base di cicli, output-> grafo contenimento)
Assembling -> creazione delle celle piene e bucate (input-> V,EV, base di cicli,grafo contenimento output-> EV,FV)
Output -> V,EVs,FVs (EV e FV per ogni componente)
