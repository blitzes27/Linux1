#!/bin/bash

# BONUS DEL ÄR GJORD MEN BARA "TA BORT OPERATION"

# skriptet har lagts i ubuntu server, i mappen /usr/local/sbin
# i den mappen ligger skrippt som endast administratörer kan köra
# jag gav en sökväg till skriptet i ~/.bashrc. sökvägen jag angav var
# export PATH="$PATH:/usr/local/sbin/user_mngt.sh"

# Kontrollerar om exakt ett argument angetts och om det stämmer så kontrollerar
# koden om det är det enda tillåtna filnamn skriptet tar.
if [ $# -eq 1 ] && [ "$1" = "users.csv" ]; then
    # döper om det givna argumentet till ex_fil
    ex_fil="$1"
    felkod=1

    # Här kontrollerar koden om argumentet är en existerande fil och om den är vanlig
    # Om filen inte uppfyllet ovanstående krav så kommer ett meddelande till stderror skickas
    if [ -f "$1" ]; then

        # Om det är en vanlig fil så substituerar jag en kod med namnet kent för att undvika att behöva skapa en fil.
        # Koden tar den inmatade filen "ex_fil" och skiljer ut dom första två kolumnerna separerade av ett ','. Sedan tar den bort
        # alla rader som innehåller ordet remove och resultatet blir att rader med add är kvar. sedan skriver den ut
        # dom första 3 orden i kolumn ett ihopsatt med dom första 3 orden i kolumn två för varje kvarvarande rad.

        kent() {

            cat "$ex_fil" | awk '!/remove/' | awk -F',' '{ print substr($1, 1, 3)substr($2, 1, 3) }'
        }
        felkod=2

        # Här ger jag variabeln "anvandare" en rad åt gången och använder informationen i varje rad till att skapa en avnändare
        # jag skriver även ut resultatet till stdout och input

        while IFS= read -r anvandare; do
            adduser --disabled-login --gecos "" $anvandare 2>/dev/null

            if [ $? -eq 0 ]; then
                echo " $anvandare har nu ett konto" >>fil_till
                felkod=3
            else
                echo "Antingen har $anvandare ett konto eller så gick det ej att lägga till." >&2
                felkod=4
            fi
            felkod=5
        done < <(kent)

        # BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL

        # BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL

        # BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL, BONUS DEL

        # Denna är precis likadan som ovan bara att den tar bort anvandare som har remove någonstans i sin rad.

        kent2() {

            cat "$ex_fil" | awk '!/add/' | awk -F',' '{ print substr($1, 1, 3)substr($2, 1, 3) }'

        }

        while IFS= read -r anvandare2; do

            deluser --remove-home $anvandare2 2>/dev/null

            if [ $? -eq 0 ]; then
                echo "latmasken '$anvandare2' har blivit sparkad, kontot är nu bortaget" >>ta_bort
                felkod=3
            else
                echo "Antingen finns det inget konto för $anvandare2 eller så gick det ej att radera" >&2
                felkod=6
            fi
            felkod=7
        done < <(kent2)

    else
        felkod=8
        echo " '$ex_fil' Hittas ej eller så är det en ogiltig fil" >&2
    fi
    felkod=9
else

    echo "för få, för många eller felaktiga argument. Jag accepterar bara 1 tusenkronors sedel" >&2
    felkod=10

fi
exit "$felkod"
