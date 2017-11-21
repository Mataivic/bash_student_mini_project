# coding: utf-8

import matplotlib.pyplot as plt

# Ouverture et lecture du fichier de données, conversion en un tableau
data = open("temp_tableau.txt", "r")
data_list=data.read()
data_list = data_list.splitlines()

tableau_final=[]
for line in data_list:
    extract=line.split(' ')
    tableau_final.append(extract)

# Chaque colonne du tableau est extraite dans une liste qui lui est propre

abs_annees=[]
ord_pop_age1=[]
ord_pop_age2=[]
ord_pop_age3=[]
ord_pop_age4=[]
ord_pop_age5=[]
ord_pop_age6=[]
ord_pop_age7=[]
ord_pop_age8=[]
ord_pop_age9=[]
ord_pop_age10=[]
ord_pop_age11=[]
ord_pop_age12=[]

for line in range(len(tableau_final)-1):
    abs_annees.append(tableau_final[line][0])
    ord_pop_age1.append(tableau_final[line][1])
    ord_pop_age2.append(tableau_final[line][2])
    ord_pop_age3.append(tableau_final[line][3])
    ord_pop_age4.append(tableau_final[line][4])
    ord_pop_age5.append(tableau_final[line][5])
    ord_pop_age6.append(tableau_final[line][6])
    ord_pop_age7.append(tableau_final[line][7])
    ord_pop_age8.append(tableau_final[line][8])
    ord_pop_age9.append(tableau_final[line][9])
    ord_pop_age10.append(tableau_final[line][10])
    ord_pop_age11.append(tableau_final[line][11])
    ord_pop_age12.append(tableau_final[line][12])

# Plot de l'ensemble des classes d'âges

plt.plot(abs_annees, ord_pop_age1, label="total 0-9 ans")
plt.plot(abs_annees, ord_pop_age2, "o-", label="total 10-19 ans")
plt.plot(abs_annees, ord_pop_age3, "^-", label="total 20-29 ans")
plt.plot(abs_annees, ord_pop_age4, "<-", label="total 30-39 ans")
plt.plot(abs_annees, ord_pop_age5, ">-", label="total 40-49 ans")
plt.plot(abs_annees, ord_pop_age6, "s-", label="total 50-59 ans")
plt.plot(abs_annees, ord_pop_age7, "p-", label="total 60-69 ans")
plt.plot(abs_annees, ord_pop_age8, "*-", label="total 70-79 ans")
plt.plot(abs_annees, ord_pop_age9, "h-", label="total 80-89 ans")
plt.plot(abs_annees, ord_pop_age10, "+-", label="total 90-99 ans")
plt.plot(abs_annees, ord_pop_age11, "x-", label="total 100-109 ans")
plt.plot(abs_annees, ord_pop_age12, "d-", label="total 110+ ans")

abscisse_min = int(abs_annees[0])
abscisse_max = int(abs_annees[-1])
plt.grid(True)
plt.legend(bbox_to_anchor=(1, 1), bbox_transform=plt.gcf().transFigure, prop={'size':6})
plt.axis([abscisse_min, abscisse_max, 0, None])
plt.xlabel("Annees")
plt.ylabel("Population")
plt.savefig("population.png")

data.close()
