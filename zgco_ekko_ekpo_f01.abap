*&---------------------------------------------------------------------*
*& Include          ZGCO_EKKO_EKPO_F01
*&---------------------------------------------------------------------*

*1/ L'utilisateur final souhaite disposer d'un report lui permettant
* d'afficher les informations des commandes d'achats
* Ci-dessous, la liste des champs à afficher :
* EBELN  Document achat EKKO, EKPO
* EBELP  Poste EKPO
* BUKRS  Société EKKO
* BSTYP  Catégorie doc. EKKO
* BSART  Type document EKKO
* Fournisseur LIFNR EKKO
* Organis. achats EKORG EKKO
* MATNR EKPO
* MENGE EKPO
* MEINS EKPO
* VOLUM EKPO
* VOLEH EKPO
* VBELN Livraison EKES


*2/ L'utilisateur souhaite pouvoir "filtrer" cette sélection de données
* en fonction du n° commande d'achat - ebeln / de l'article - matnr / de la société - bukrs
* Il indique que le critère "société" doit être un critère obligatoire
* et que sa valeur par défaut sera "0001'.

*3/ L'utilisateur souhaite également disposer d'une case à cocher lui
* permettant d'afficher ou non le volume de l'article


*4/ L'utilisateur précise enfin qu'il a besoin de messages d'information
* dans l'éventualité où il renseignerait une société qui n'existe pas.
* et dans l'éventualité où aucune information ne serait récupérée.

*&---------------------------------------------------------------------*
*& Form select_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM select_data .

*****************************************************************  First selection
    
      IF rb1 IS NOT INITIAL. " This means rb1 is choosed.
    
        SELECT ekko~ebeln, ekko~bukrs, ekko~bstyp, ekko~bsart, ekko~lifnr, ekko~ekorg,
          ekpo~ebelp, ekpo~matnr, ekpo~menge, ekpo~meins, ekpo~volum, ekpo~voleh
    
          FROM ekko
          INNER JOIN ekpo ON ekko~ebeln = ekpo~ebeln
          INTO TABLE @DATA(lt_data)
          WHERE ekko~ebeln IN @s_ebeln
           AND ekpo~matnr IN  @s_matnr
           AND ekko~bukrs IN @s_bukrs.
    
    
        IF  sy-subrc <> 0.
          MESSAGE TEXT-002 TYPE 'E'.
        ELSE.
          MESSAGE TEXT-003 TYPE 'S'.
        ENDIF.
    
        IF p_volum <> 'X'. " This means p_volum is not initial, p_volum is not selected
          MESSAGE TEXT-004 TYPE 'W'.
        ENDIF.
    
        DATA : lo_alv TYPE REF TO cl_salv_table.
    
        CALL METHOD cl_salv_table=>factory
          IMPORTING
            r_salv_table = lo_alv
          CHANGING
            t_table      = lt_data.
    
        CALL METHOD lo_alv->display.
    
    
*****************************************************************  Second selection
    
      ELSEIF rb2 = 'X'.
    
        SELECT ekko~ebeln, ekko~bukrs, ekko~bstyp, ekko~bsart, ekko~lifnr,
          ekpo~ebelp, ekpo~matnr, ekpo~menge, ekpo~meins
          FROM ekko
          INNER JOIN ekpo ON ekko~ebeln = ekpo~ebeln
          INTO TABLE @DATA(lt_data2)
           WHERE ekko~ebeln IN @s_ebeln
             AND ekpo~matnr IN @s_matnr
             AND ekko~bukrs IN @s_bukrs.
    
        IF  sy-subrc <> 0.
          MESSAGE TEXT-002 TYPE 'E'.
        ELSE.
          MESSAGE TEXT-003 TYPE 'S'.
        ENDIF.
    
        IF p_volum <> 'X'. " This means p_volum is not initial, p_volum is not selected
          MESSAGE TEXT-004 TYPE 'W'.
        ENDIF.
    
    
    
        CALL METHOD cl_salv_table=>factory
          IMPORTING
            r_salv_table = lo_alv
          CHANGING
            t_table      = lt_data2.
    
        CALL METHOD lo_alv->display.
    
************************************************************************ third selection, APPEND
    
    
        TYPES : BEGIN OF ty_table,
                  ebeln TYPE ekko-ebeln,
                  bukrs TYPE ekko-bukrs,
                  bstyp TYPE ekko-bstyp,
                  bsart TYPE ekko-bsart,
                  lifnr TYPE ekko-lifnr,
                  ebelp TYPE ekpo-ebelp,
                  matnr TYPE ekpo-matnr,
                  menge TYPE ekpo-menge,
                  meins TYPE ekpo-meins,
                  volum TYPE ekpo-volum,
                  voleh TYPE ekpo-voleh,
                  vbeln TYPE ekes-vbeln,
                END OF ty_table.
    
        DATA : lt_data3 TYPE STANDARD TABLE OF ty_table WITH NON-UNIQUE KEY ebeln,
               ls_data3 TYPE ty_table.
    
    
      ELSEIF rb3 = 'X'.
        SELECT ekko~ebeln,
               ekko~bukrs,
               ekko~bstyp,
               ekko~bsart,
               ekko~lifnr,
               ekpo~ebelp,
               ekpo~matnr,
               ekpo~menge,
               ekpo~meins,
               ekpo~volum,
               ekpo~voleh,
               ekes~vbeln
    
          FROM ekko
          INNER JOIN ekpo ON ekko~ebeln = ekpo~ebeln
          INNER JOIN ekes ON ekes~ebeln = ekko~ebeln
          INTO TABLE @lt_data3
           WHERE ekko~ebeln IN @s_ebeln
             AND ekpo~matnr IN @s_matnr
             AND ekko~bukrs IN @s_bukrs.
    
        ls_data3-ebeln = '4500000022'.
        ls_data3-ebelp = '20'.
        ls_data3-bukrs = '1710'.
        ls_data3-bstyp = 'F'.
        ls_data3-bsart = ' NB'.
        ls_data3-lifnr = '0017300007 '.
        ls_data3-matnr = 'TG11'.
        ls_data3-menge = 10.
        ls_data3-meins = 'ST'.
        ls_data3-volum = '1'.
        ls_data3-voleh = 'L'.
        ls_data3-vbeln = '180000078'.
    
        APPEND ls_data3 TO lt_data3.
    
        IF p_volum <> 'X'. " This means p_volum is not initial, p_volum is not selected
          MESSAGE TEXT-004 TYPE 'W'.
        ENDIF.
    
    
        CALL METHOD cl_salv_table=>factory
          IMPORTING
            r_salv_table = lo_alv
          CHANGING
            t_table      = lt_data3.
    
        CALL METHOD lo_alv->display.
    
    
************************************************************************ third selection, MODIFY
    
        ls_data3-ebeln = '4500000022'.
        ls_data3-ebelp = '20'.
        ls_data3-bukrs = '1710'.
        ls_data3-bstyp = 'F'.
        ls_data3-bsart = ' NB'.
        ls_data3-lifnr = '0017300007 '.
        ls_data3-matnr = 'TG11'.
        ls_data3-menge = 10.
        ls_data3-meins = 'ST'.
        ls_data3-volum = '12345'.
        ls_data3-voleh = 'L'.
        ls_data3-vbeln = '180000078'.
    
        MODIFY lt_data3 FROM ls_data3  TRANSPORTING volum WHERE ebeln = '4500000022'.
    
        IF  sy-subrc <> 0.
          MESSAGE TEXT-006 TYPE 'E'.
        ELSE.
          MESSAGE TEXT-005 TYPE 'S'.
        ENDIF.
    
        CALL METHOD cl_salv_table=>factory
          IMPORTING
            r_salv_table = lo_alv
          CHANGING
            t_table      = lt_data3.
    
        CALL METHOD lo_alv->display.
    
    
************************************************************************ third selection, DELETE
    
        DELETE lt_data3  WHERE ebeln = '4500000022'.
    
        IF  sy-subrc = 0.
          MESSAGE TEXT-007 TYPE 'S'.
        ELSE.
          MESSAGE TEXT-008 TYPE 'E'.
        ENDIF.
    
        CALL METHOD cl_salv_table=>factory
          IMPORTING
            r_salv_table = lo_alv
          CHANGING
            t_table      = lt_data3.
    
        CALL METHOD lo_alv->display.
    
************************************************************************ fourth selection, SPLIT METHOD
    
    
      ELSEIF    rb4 = 'X'.
    
        TYPES: BEGIN OF ty_string,
                 string(25) TYPE c,
               END OF ty_string.
    
        DATA : lv_string TYPE string,
               lt_string TYPE TABLE OF ty_string,
               ls_string TYPE ty_string.
    
    
        lv_string = 'SPLIT ME AT SPACE'.
    
        SPLIT lv_string AT ' ' INTO TABLE lt_string.
    
        LOOP AT  lt_string INTO ls_string.
          WRITE : ls_string.
    
        ENDLOOP.
    
      ENDIF.
    
    ENDFORM.