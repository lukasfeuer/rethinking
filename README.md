# Statistical Rethinking - Notizen

## Kapitel 2 

- Analogie der kleinen und großen Welt (Beispiel Columbus):
	- Die Kleine Welt ist die Welt des Modells. Wenn sie schlüssig und logisch hergeleitet wird, kann mit bayesianischem Vorgehen eine optimale Vorhersage auf Basis der verfügbaren Daten vorgenommen werden. 
	- Die große Welt ist die echte Welt auf welche wir das Modell übertragen wollen und für die wir Vorhersagen treffen wollen. Dies funktioniert nur, wenn die Kleine Welt bzw. das Modell eine möglichst akkurate Repräsentation der echten Welt darstellt
- Garden of forking data: alle bayesianischen Analysen können auf das Auszählen eines Entscheidungsbaums zurückgeführt werden. Für jeden möglichen Wert, den ein Parameter annehmen kann, wird die Anzahl an möglichen Wegen (Likelihood) ausgezählt, mit der dieser Parameterwert die Daten erzeugt haben könnte. Neue Beobachtungen in den Daten können multiplikativ ergänzt werden
- Die Art, wie bayesianische Modelle aus Information lernen ist ideal (in der kleinen Welt), vorausgesetzt das Modell beschreibt tatsächlich die große Welt. Jedoch muss das Modell nicht "wahr" sein, um nütziche Vorhersagen zu liefern. 
- Die Schätzung eines b. Modells benötigt keine "Mindest-Stichprobengröße"
- **Likelihood** bezeichnet i.d.R. eine Verteilungsfunktion (z.B. Binomialverteilung), die einer beobachteten Varablen zugeordnet ist (z.B. "Land-Beobachtungen" in dem Globus-Beispiel)
- **Binomialverteilung** ("Münze werfen")
	- *Maximale Entropie*: es gibt nur zwei mögliche Ausprägung und deren Wahrscheinlichkeiten sind immer p und 1-p
	- Jede Beobachtung ist unabhängig von den anderen 
	- Die Wahrscheinlichkeit für die Beobachtung des interessierenden Phänomens bleibt immer gleich
- **Prior**: jeder Parameter im Modell benötigt eine a-priori Wahrscheinlichkeit
- Die meisten "interessanten" Modelle sind bereits so komplex, dass sie selbst von erfahrenen Mathematikern nicht *formal konditioniert* werden können (z.B. Berechnung eines Integrals?). Daher bedient man sich verschiedener *conditioning engines*, numerischer Techniken, um Posterior-Verteilungen zu errechnen (Produkt aus Prior und Likelihood)
- **Markov Chain Monte Carlo** *MCMC* ist eine der am weitesten verbreiteten Methoden. Hier anfänglich zu Anschauungszwecken verwendet werden außerdem **Grid Approximation** und **Quadratic Approximation**
- Diese numerischen *Fitting Techniques* sind gleichfalls selbst Teil des Modells. Bis auf bei sehr simplen Modellen kann die Wahl der numerischen Technik einen bedeutenden Einfluss auf das Modellergebnis haben, da je nach Technik unterschiedliche Kompromisse eingegangen werden müssen 


## Kapitel 3

- Beispielfall für die Bayes-Formel
	- Vampirtest kann 95% der Vampire erkennen 
	- 1% der positiven Diganosen ist falsch (Menschen)
	- Es gibt nur sehr wenig Vampire, etwa 0,1%
	- Ergebnis: pr(Vampir|+) = 0.0868
- Stichproben aus der Posterior-Veteilung: bisherige Beispiele waren so einfach, dass man direkt mit der Posterior-Verteilung arbeiten kann. In komplexeren Modellen wäre dies jedoch äußerst herausfordernd. Es ist daher einfacher, Stichproben von der Posterior-Verteilung zu ziehen und diese zusammenzufassen und zu beschreiben. MCMC gibt darüber hinaus sowieso nur Stichproben aus der Posterior-Verteilung aus 
- Es erscheint zunächst trivial und unnötig, dass mit dem Sampling die "wahre" Posterior nur annährungsweise nachgebildet wird. Der zentrale nächste Schritt ist jedoch die "Beschriebung" der Posterior-Verteilung und dies ist sehr viel einfacher mit der Zusammenfassung von Stichproben getan als analytisch.
- Drei "Arten" von Zusammenfassungen sind dabei von zentralem Interesse
	- Intervalle mit definierten Grenzen
	- Intervalle mit definierter "Wahrscheinlichkeitsmasse"
	- Punktschätzungen 
- **Highest Posterior Density Interval *(HPDI)***: Definiert das schmalste mögliche Intervall für eine bestimmte "Wahrscheinlichkeitsmasse" in einer Verteilung. Weniger weit geläufig und daher ggf. kontrovers. Normales **Perzentil Intervall *(PI)*** ist geläufiger und häufig dem HPDI sehr ähnlich. Wenn die Wahl des Intervalls einen Unterschied macht, sollte man sowieso die gesamte Posterior darstellen anstatt eines Intervalls
- Es gibt kein "richtiges" Intervall, für die Konvention des 95%-Intervalls spricht lediglich die Konvention. Sinnvoll erscheint es, mehrere Intervalle zu berichten, welche die Form der Verteilung kommunizieren, z.B. 67%, 89% und 97%
- Interpretation von nicht-bayesianischen 95%-Konfidenzintervallen: wenn man die Studie und Analyse sehr häufig wiederholen würde, dann enthalten 95% der dort errechneten Konfidenzintervalle den "wahren" Parameterwert 
- Punktschätzungen sind so gut wie nie notwendig und oft sogar schädlich. Die bayesianische Parameterschätzung ist exakt die **gesamte Posterior** Verteilung
	- **MAP** Maximum a-posteriori Schätzung - der Einzelwert mit der höchsten posterior prob -> Modus. Alternativ können auch Median und Mittelwert verwendet werden. Welche Schätzung "richtig" ist hängt von der jeweilig zugrundegelegten Verlustfunktion (Loss) ab
	- **Loss Function**: Methode nach welcher der "Verlust"/Kosten einer Entscheidung für jeden möglichen Parameterwert errechnet wird. Absoluter Verlust (siehe Code) führt zur adoption des Medians, quadratischer Verlust nominiert den Mittelwert. Je nach tatsächlichen "Kosten" bzw. Risiken, welche eine Entscheidung nach sich zieht, kann auch eine noch strengere/aggressivere Verlustfunktion verwendet werden 
- Simulation von Vorhersagen 
	- nützlich für verschiedene Aspekte, z.B. wie verhält sich das Modell bevor Daten einfließen, Modellkritik und Modellrevision sowie Forecasting
	- Bayesianische Modelle sind immer generativ und können Daten simulieren 
	- Model Check: Simulationen eines trainierten Modells sollten mit den verwendeten Daten korrespondieren 
- **Posterior Predictive Distribution**: für jeden möglichen Parameterwert aus der Posterior wird eine Simulation von Beobachtungen vorgenommen. Alle diese simulierten Beobachtungen werden mit einander gewichtet kombiniert (unter Berücksichtigung der prob ihres jeweiligen Parameterwertes). Die Simulierte Verteilung von Parameterwerten mit höherer prob in der Posterior fließen mit größerem Gewicht in die Posterior Predictive Distribution ein 


## Kapitel 4

- Jeder Prozess, welcher Zufallszahlen aus der gleichen Verteilung miteinander addiert, nährt sich einer Normalverteilung an 
- Auch bei multiplikativer Interaktion kleiner Effekte kann eine Normalverteilung resultieren, solange die Effekte nicht zu groß sind. Bei kleinen prozentualen Effekten ist das Ergebnis der Multiplikation sehr ähnlich der Addition und führt daher zum gleichen Ergebnis (1,1 * 1,1 = 1,21). Für größere Deviationen gilt dies immer noch, wenn die Werte logarithmiert werden
- Die **Gauss-Verteilung** bzw. Normalverteilung ist ein Mitglied der Familie der **Exponentiellen Verteilungen**. Hierbei handelt es sich um mehrere fundamentale natürliche Verteilungen 
- Wenn wir nur eine Aussage über den Mittelwert und die Streuung einer Verteilung treffen können/wollen, dann stimmt die Normalverteilung in diesem Fall am besten mit unseren Annahmen überein. Wenn eine andere Verteilung gewählt wird, dann nur begründet weil eine bestimmte Information bekannt ist, welche die Inferenz verbessern kann 
- Die Normalverteilung hat vergleichsweise geringe Wahrscheinlichkeitsmassen in ihren Ausläufern und unterschätzt daher die Wahrscheinlichkeit extremer Ereignisse in einigen natürlichen oder unnatürlichen Prozessen 
- Modellsprache / Notation 
	- Tilde `~` definiert einen stochastischen Zusammenhang zwischen einer Variablen/Parameter und einer Verteilungsfunktion 
	- Deterministischer Zusammenhang definiert durch `=`
- Gauss-Modell für Köpergröße:
	- likelihood: h<sub>i</sub> ~ Normal(µ, σ)
	- µ prior: µ ~ Normal(178, 20)
	- σ prior: σ ~ Uniform(0,50)
- **Prior Predictive Simulation** ist ein essenzieller Teil des Modellierens. Die Simulation zeigt die Implikationen der gewählten Priors (hier z.B. für die Verteilung von Körpergrößen). Dabei werden jeweils Zufallsstichproben aus den beiden Prior-Verteilungen oben gezogen und in die Likelihood eingefügt, daraus ergibt sich die Simulationen der erwarteten Verteilung von Körpergrößen. Diese Verteilung selbst muss nicht "gaussian" sein, da sie keine empirische Annahme darstellt sondern lediglich die erwartete Plausibilität verschiedener Körpergrößen, bevor die Daten bekannt sind
- Die Wahl eines sinnvollen Prior kann durch die Simulation gestützt werden und unsinnige Varianten können von vornherein ausgeschlossen werden. Auch wissenschaftliche Erkenntnisse dürden die Wahl des Priors beeinflussen, nur keine Erkenntnisse, welche direkt aus den Daten stammen. Alles was wir vorher über die Daten wissen, bevor wir diese selbst sehen, ist jedoch erlaubt (z.B. auch "Erfahrung"). 
- Da jede Posterior auch wiederum eine Prior sein kann, funktioniert die PPS genau so wie die Posterior Predictive Distribution 
- **Marginal Distribution** (z.B. Posterior für einen Parameter des Modells für Körpergröße): die Verteilung für die Plausibilität jedes Wertes für µ, gemittelt über die Plausibilität jedes möglichen Werts für σ
- Wenn ein sehr strikter Prior für einen bestimmten Parameter gewählt wird (welcher sich sehr "sicher" ist), kann dies auch die Schätzung anderer Parameter beeinflussen, da beide mit einander in direktem Zusammenhang stehen. Wenn der Prior für µ z.B. sehr strikt ist, muss die Schätzung für σ "breiter"/unsicherer ausfallen, um der tatsächlichen Varianz in den Daten rechnung zu tragen
- Warum 89% Compatibility Intervall und nicht z.B. 95%: "89 is also a prime number, so if someone asks you to justify it, you can stare at them meaningfully and incant, "Because it is prime." That’s no worse justification than the conventional justification for 95%."
- **Varianz-Covarianz-Matrix**: die Posterior-Verteilung bei einer Quadratic Approximation mit mehr als einem Parameter (z.B. µ und σ bei der Normalverteilung) ist eine mehrdimensionale Gauss-Verteilung. Während eine eindimensionale Gauss-Verteilung nur durch einen Mittelwert und eine Standardverteilung beschrieben werden kann, benötigt man für die Beschreibung einer mehrdimensionalen Gauss-Verteilung die Mittelwerte und eine Matrix der Varianzen und Covarianzen der einzelnen geschätzten Parameter des Modells. Die Matrix aus der Funktion `vcov("model")` kann auf zwei Komponenten heruntergebrochen werden: 
	- Diagonale: Vektor der Varianzen der Parameter (Wurzel daraus ergibt die SD pro Parameter)
	- Korrelationsmatrix der Parameter (`cov2cor()`): wie stark beeinflussen sich die Parameter untereinander? 
- Stichproben aus der multivariaten Posterior werden nicht als Einzelwerte gezogen sondern als Vektoren mehrer Werte gleichzeitig
- Lineare Vorhersagen: µ wird nun deterministisch durch zwei neue Parameter erklärt, α und β, mit denen µ systematisch variiert werden kann über die Daten hinweg
- Lineares Regressionsmodell für Körpergröße mit Gewicht als Prediktor:
	- h<sub>i</sub> ~ Normal(µ<sub>i</sub>, σ)
	- µ<sub>i</sub> = α + β(x<sub>i</sub> - x̄)
	- α ~ Normal(178, 20)
	- β ~ Normal(0, 10)
	- σ ~ Uniform(0, 50)
- Anstatt α und β abstrakt als Intercept und Slope zu bezeichnen, besser die konkrete Bedeutung verinnerlichen 
	- α: Erwartungswert von h, wenn x = x̄ (da dann µ = α)
	- β: Erwartete Änderung in h, wenn x sich um eine Einheit verändert 
- **Log-Normal Prior**
	- Der Prior für β im oberen Modell ist problematisch. Eine Simulation von möglichen Regressionslinien zeigt, dass laut modell auch ein (unmöglicher) negativer Zusammenhang zwischen den Variablen möglich wäre. Um den Zusammenhang positiv festzulegen, wird ein Log-Normal Prior verwendet
	- β als Log-Normal(0, 1) zu definieren bedeutet, dass der Logarithmus von β normalverteilt ist mit Normal(0, 1)
	- β ist strikt positiv, da exp(x) > 0 für alle reellen Zahlen 
- Es gibt keinen einzig "korrekten" Prior für eine bestimmte Analyse. Mit Priors kann ein unterschiedlicher Umfang von Vorwissen in die Analyse eingebracht werden - es lohnt sich auch zu untersuchen, wie sich ein unterscheidlicher Umfang von Vorwissen auf die Inferenz auswirkt.
- **p-hacking** ist auch in bayesschen Analysen möglich, auch wenn diese keine p-Werte verwenden. Der Prior darf nicht auf Basis von Modellergebnissen angepasst werden, lediglich auf Basis von "pre-data knowledge"  
- Interpretation der Posterior: Tabellen geben schon bei leicht komplexeren Modellen keinen guten Überblick über die Modellergebnisse. Posterior daher besser auch visualisieren

Lesezeichen: 4.4.3 

Practice
https://sr2-solutions.wjakethompson.com/bayesian-inference