% ==========================================================
% Asian Dish Identification Expert System
% File: knowledge_base.pl
% Member 1 - Knowledge Base and Dish Rules
% ==========================================================

:- dynamic known/2.


% ==========================================================
% 1. BASIC DISH CATEGORIES
% ==========================================================

% Rice-based dishes
rice_dish(nasi_lemak).
rice_dish(nasi_goreng).
rice_dish(congee).
rice_dish(sushi).

% Noodle-based dishes
noodle_dish(char_kway_teow).
noodle_dish(asam_laksa).
noodle_dish(ramen).

% Dough-based dishes
dough_dish(steamed_dumplings).

% Meat-based dishes
meat_dish(satay).


% ==========================================================
% 2. BASIC CHARACTERISTIC RULES
%
% These rules read the answers stored by interaction.pl.
% ==========================================================

has_base(Base) :-
    known(base, Base).


uses_method(Method) :-
    known(method, Method).


uses_coconut_milk :-
    known(coconut_milk, yes).


has_broth :-
    known(has_broth, yes).


has_sour_fish_broth :-
    known(sour_fish_broth, yes).


has_filled_dough :-
    known(filled_dough, yes).


has_skewers :-
    known(skewers, yes).


has_dipping_sauce :-
    known(dipping_sauce, yes).


has_rice_style(Style) :-
    known(rice_style, Style).


has_sambal :-
    known(sambal, yes).


has_flat_rice_noodles :-
    known(flat_rice_noodles, yes).
    
has_fried_rice_ingredients :-
    known(fried_rice_ingredients, yes).

has_japanese_style_broth :-
    known(japanese_style_broth, yes).


has_seasoned_rice_toppings :-
    known(seasoned_rice_with_toppings, yes).

has_seasoned_meat :-
    known(seasoned_meat, yes).
% ==========================================================
% 3. INTERMEDIATE KNOWLEDGE LAYERS
% ==========================================================

% ----- Base categories -----

rice_based :-
    has_base(rice).


noodle_based :-
    has_base(noodles).


dough_based :-
    has_base(dough).


meat_based :-
    has_base(meat).


% ----- Cooking categories -----

fried_dish :-
    uses_method(fried).


steamed_dish :-
    uses_method(steamed).


grilled_dish :-
    uses_method(grilled).


broth_based :-
    has_broth.


% ----- More specific characteristics -----
fried_rice_dish :-
    rice_based,
    fried_dish,
    has_fried_rice_ingredients.

porridge_dish :-
    rice_based,
    has_rice_style(porridge).


seasoned_rice_dish :-
    rice_based,
    has_rice_style(seasoned).


filled_dough_dish :-
    dough_based,
    has_filled_dough.


skewer_dish :-
    has_skewers.


sauced_skewer_dish :-
    skewer_dish,
    has_dipping_sauce.
    
seasoned_grilled_meat :-
    meat_based,
    grilled_dish,
    has_skewers,
    has_seasoned_meat.

% ==========================================================
% 4. FINAL DISH IDENTIFICATION RULES
% ==========================================================

% ----------------------------------------------------------
% Rule 1: Nasi Lemak
% Rice + coconut milk + sambal
% ----------------------------------------------------------

identify(nasi_lemak) :-
    rice_dish(nasi_lemak),
    rice_based,
    uses_coconut_milk,
    has_sambal.


% ----------------------------------------------------------
% Rule 2: Char Kway Teow
% Noodles + fried + flat rice noodles
% ----------------------------------------------------------

identify(char_kway_teow) :-
    noodle_dish(char_kway_teow),
    noodle_based,
    fried_dish,
    has_flat_rice_noodles.


% ----------------------------------------------------------
% Rule 3: Asam Laksa
% Noodles + broth + sour fish-based broth
% ----------------------------------------------------------

identify(asam_laksa) :-
    noodle_dish(asam_laksa),
    noodle_based,
    broth_based,
    has_sour_fish_broth.


% ----------------------------------------------------------
% Rule 4: Ramen
% Noodles + broth + Japanese-style broth
% ----------------------------------------------------------

identify(ramen) :-
    noodle_dish(ramen),
    noodle_based,
    broth_based,
    has_japanese_style_broth.


% ----------------------------------------------------------
% Rule 5: Congee
% Rice + porridge-style rice
% ----------------------------------------------------------

identify(congee) :-
    rice_dish(congee),
    porridge_dish.


% ----------------------------------------------------------
% Rule 6: Steamed Dumplings
% Dough + filling + steamed
% ----------------------------------------------------------

identify(steamed_dumplings) :-
    dough_dish(steamed_dumplings),
    filled_dough_dish,
    steamed_dish.


% ----------------------------------------------------------
% Rule 7: Sushi
% Seasoned rice + fish/vegetable toppings
% ----------------------------------------------------------

identify(sushi) :-
    rice_dish(sushi),
    seasoned_rice_dish,
    has_seasoned_rice_toppings.


% ----------------------------------------------------------
% Rule 8: Satay
% Meat + grilled + skewers + dipping sauce
% ----------------------------------------------------------

identify(satay) :-
    meat_dish(satay),
    meat_based,
    grilled_dish,
    sauced_skewer_dish.


% ----------------------------------------------------------
% Rule 9: Nasi Goreng
% Rice + fried + fried rice ingredients
% ----------------------------------------------------------

identify(nasi_goreng) :-
    rice_dish(nasi_goreng),
    fried_rice_dish.


% ==========================================================
% 5. LIST OF SUPPORTED DISHES
% ==========================================================

possible_dish(nasi_lemak).
possible_dish(char_kway_teow).
possible_dish(asam_laksa).
possible_dish(ramen).
possible_dish(congee).
possible_dish(steamed_dumplings).
possible_dish(sushi).
possible_dish(satay).
possible_dish(nasi_goreng).