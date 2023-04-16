*&---------------------------------------------------------------------*
*& Include          ZGCO_EKKO_EKPO_SCR
*&---------------------------------------------------------------------*

*2/ L'utilisateur souhaite pouvoir "filtrer" cette sélection de données
* en fonction du n° commande d'achat - ebeln / de l'article - matnr / de la société - bukrs
* Il indique que le critère "société" doit être un critère obligatoire
* et que sa valeur par défaut sera "0001'.
TABLES : ekko, ekpo.

SELECTION-SCREEN BEGIN OF BLOCK b0 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS : s_ebeln FOR ekko-ebeln,
                   s_matnr FOR ekpo-matnr,
                   s_bukrs FOR ekko-bukrs OBLIGATORY DEFAULT '0001'.


*3/ L'utilisateur souhaite également disposer d'une case à cocher lui
* permettant d'afficher ou non le volume de l'article

  PARAMETERS : p_volum AS CHECKBOX DEFAULT 'X'.

  PARAMETERS : rb1 RADIOBUTTON GROUP b1,
               rb2 RADIOBUTTON GROUP b1,
               rb3 RADIOBUTTON GROUP b1,
               rb4 RADIOBUTTON GROUP b1.

SELECTION-SCREEN END OF BLOCK b0.