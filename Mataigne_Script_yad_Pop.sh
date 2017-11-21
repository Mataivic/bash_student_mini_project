#!/bin/bash
# Auteur : Victor Mataigne
# Date : 18/09/2016
# But : A partir d'un fichier regroupant la population par âge et par année de différents pays, regrouper ces effectifs en tranches d'âge, pour chaque année et chaque pays. Les résultats sont présentés dans des fichiers html (un par pays).
# Remarques diverses : voir à la fin du script

cp population.txt population2.txt # Crée une copie du fichier

temp_list_pays=$(cut -f1 -d" " population2.txt | sort -u) # Crée une liste des pays pour la commande yad (une checklist)
for ligne in $temp_list_pays
 do   
   echo -e "false\n$ligne" >> temp_list_pays_adapted.txt # Ajoute des lignes "false" (1 ligne sur 2), requises pour la checklist yad.
done
yad --height=800 --width=250 --list --checklist --column=Choix --column=Pays < temp_list_pays_adapted.txt > temp_choix.txt
choix2=$(cut -f2 -d"|" temp_choix.txt) # Récupère les pays sélectionnés dans une variable

for pays in $choix2
	do
		grep -w $pays population2.txt > temp_pays # Crée un fichier temporaire "pays" pour chaque pays choisi (avec toutes ses années)
		cp Fichier_final_debut.html Demographie_$pays.html # Crée le fichier html pour les résultats à partir du modèle
		sed -i -e "s/Demographie/$pays/" Demographie_$pays.html # Renomme le titre de la page au nom du pays
		sed -i -e "s/Pays/$pays/" Demographie_$pays.html # Renomme le titre h1 au nom du pays
		# sed -i -e "s/_/ /" Demographie_$pays.html

		cut -f2 -d' ' temp_pays | sort -u > temp_lst_ans.txt # Crée une liste des années de rescencement
		sed -i -e'/+/d' temp_lst_ans.txt # Supprimme les années notées "année+"
		sed -i -e'/-/d' temp_lst_ans.txt # Supprimme les années notées "année-"
		ANNEE=$(cut -f1 -d' ' temp_lst_ans.txt | sort -u) # Replace cette liste dans une variable
		
		for annee in $ANNEE
			do
				grep -w $annee temp_pays > temp_annee # Crée un fichier temporaire pour chaque année de chaque pays				
				sed -i -e "s/110+/110/g" temp_annee # Enlève les "+" présents dans les âges "110+"
				sed -i -e "s/\...//g" temp_annee # Enlève les décimales des colonnes d'effectifs
				cp Fichier_final_body.html temp_body # Crée un fichier temporaire contenant le code html, à partir du modèle
				sed -i -e "s/annee/$annee/" temp_body # Ecrit l'année correspondante au dessus du tableau

				for i in  {0..11}
					do # Calcul des effectifs par tranche d'âge, stocké dans une variable, puis écriture dans le tableau html
						nh_nf_t=($(awk -F" " '$3>='$i'0 && $3<='$i'9{h+=$4; f+=$5; t+=$6} END{print h" "f" "t}' temp_annee))
						sed -i -e"s/nh$i/${nh_nf_t[0]}/" -e"s/nf$i/${nh_nf_t[1]}/" -e"s/t$i/${nh_nf_t[2]}/" temp_body
						# Les lignes suivantes préparent le tableau de données qui sert à la construction des graphes
						awk -F" " '$3>='$i'0 && $3<='$i'9{t+=$6} END{print t}' temp_annee > temp_tot.txt
						cat temp_tot.txt | tr '\n' ' ' >> tot_adapted.txt						
				done
				echo '\n' >> tot_adapted.txt
				cat temp_body >> Demographie_$pays.html # Ajout de l'ensemble au fichier html final				
	  done  

  paste -d' ' temp_lst_ans.txt tot_adapted.txt > temp_tableau.txt	
	rm tot_adapted.txt
	python Script_graphes.py
	cp population.png population_$pays.png
  sed -i "s/adresse/population_$pays.png/" Demographie_$pays.html
	cat Fichier_final_fin.html >> Demographie_$pays.html # Ajout de la fin du fichier html
	rm *temp* # Supprime les fichiers temporaires	
done

rm population2.txt # Supprime la copie
rm population.png

# Remarques diverses:

# 1/ La commande sed qui enlève les décimales est une  troncature : les totaux calculés peuvent différer de +/-1 des totaux du jeu de 	  données
# 2/ Parfois, certaines années sont dupliquées (notamment pour la Belgique), notées "année+" et "année-". Les chiffres étant semblables, on suppose que la population a été rescencée deux fois dans la même année. Le choix a été fait de supprimer ces années des données, notamment pour avoir des graphes sans erreurs.
# 3/ Il reste 2 bugs : 
  # les deux dernières tranches d'âge sont fausses dans les tableaux: les effectifs de la tranche d'âge 10-10 ans s'y ajoutent. Ni l'auteur ni les collègues de M2.1 n'ont réussi à trouver pourquoi pour l'instant. On soupçonne la commande sed ou les quotes "" ou ''... En revanche, les valeurs indiquées sur les graphes sont justes
  # Les tableaux de rescencement pour la Belgique de 1915 à 1918 sont vides, mis à part la tranche d'âge 90-99 ans.



