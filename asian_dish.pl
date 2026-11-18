% Asian Dish Identification Expert System

% Stores user answers dynamically as known(Attribute, Value)
:- dynamic known/2.


% Knowledge base and dish identification rules

% 1. Basic dish categories
% Group each supported dish by its primary base ingredient

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


% 2. Basic characteristic rules
% Map stored user answers from known/2 into readable predicates

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


% 3. Intermediate knowledge layers
% Combine basic characteristics into higher-level dish traits

% Base categories
rice_based :-
    has_base(rice).

noodle_based :-
    has_base(noodles).

dough_based :-
    has_base(dough).

meat_based :-
    has_base(meat).

% Cooking categories
fried_dish :-
    uses_method(fried).

steamed_dish :-
    uses_method(steamed).

grilled_dish :-
    uses_method(grilled).

broth_based :-
    has_broth.

% More specific characteristics
fried_rice_dish :-
    rice_based,
    fried_dish,
    has_fried_rice_ingredients.

porridge_dish :-
    rice_based,
    has_rice_style(porridge).

% Handles seasoned rice style or unknown rice style with confirmed toppings
seasoned_rice_dish :-
    rice_based,
    ( has_rice_style(seasoned)
    ; known(rice_style, unknown)
    ).

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


% 4. Final dish identification rules
% Each rule checks the category and required traits for a specific dish

% Rule 1: Nasi Lemak (rice + coconut milk + sambal)
identify(nasi_lemak) :-
    rice_dish(nasi_lemak),
    rice_based,
    uses_coconut_milk,
    has_sambal.

% Rule 2: Char Kway Teow (fried flat rice noodles)
identify(char_kway_teow) :-
    noodle_dish(char_kway_teow),
    noodle_based,
    fried_dish,
    has_flat_rice_noodles.

% Rule 3: Asam Laksa (noodles in sour fish broth)
identify(asam_laksa) :-
    noodle_dish(asam_laksa),
    noodle_based,
    broth_based,
    has_sour_fish_broth.

% Rule 4: Ramen (noodles in Japanese-style broth)
identify(ramen) :-
    noodle_dish(ramen),
    noodle_based,
    broth_based,
    has_japanese_style_broth.

% Rule 5: Congee (porridge-style rice)
identify(congee) :-
    rice_dish(congee),
    porridge_dish.

% Rule 6: Steamed Dumplings (steamed filled dough)
identify(steamed_dumplings) :-
    dough_dish(steamed_dumplings),
    filled_dough_dish,
    steamed_dish.

% Rule 7: Sushi (seasoned rice with fish or vegetable toppings)
identify(sushi) :-
    rice_dish(sushi),
    seasoned_rice_dish,
    has_seasoned_rice_toppings.

% Rule 8a: Satay with dipping sauce
identify(satay) :-
    meat_dish(satay),
    meat_based,
    grilled_dish,
    sauced_skewer_dish.

% Rule 8b: Satay with seasoned/marinated meat fallback when dipping sauce is not confirmed
identify(satay) :-
    meat_dish(satay),
    seasoned_grilled_meat,
    \+ has_dipping_sauce.

% Rule 9: Nasi Goreng (fried rice with stir-fry ingredients)
identify(nasi_goreng) :-
    rice_dish(nasi_goreng),
    fried_rice_dish.


% 5. List of supported dishes
% Reference list of all dishes the system can identify

possible_dish(nasi_lemak).
possible_dish(char_kway_teow).
possible_dish(asam_laksa).
possible_dish(ramen).
possible_dish(congee).
possible_dish(steamed_dumplings).
possible_dish(sushi).
possible_dish(satay).
possible_dish(nasi_goreng).



% 1. Start the system
% Entry point: clears previous session facts, prints instructions, and runs identification

identify :-
    clear,
    nl,
    writeln('=================================================='),
    writeln('     ASIAN DISH IDENTIFICATION EXPERT SYSTEM'),
    writeln('=================================================='),
    writeln('Answer the questions using the available choices.'),
    writeln('Note: Enter the choice number followed by a period (e.g. 1. or 2.).'),
    writeln('Choose Unknown if you are not sure.'),
    nl,
    identify_dish.


% 2. Reset memory
% Remove all stored known/2 facts from previous runs

clear :-
    retractall(known(_, _)).


% 3. Main identification process
% Ask for the main base, branch into base-specific questions, then display the result

identify_dish :-
    ask_base,
    continue_from_base,
    finish_identification.


% 4. Choose question path based on main base
% Branch to the relevant follow-up questions; cuts prevent backtracking into other branches

continue_from_base :-
    known(base, rice),
    !,
    rice_questions.

continue_from_base :-
    known(base, noodles),
    !,
    noodle_questions.

continue_from_base :-
    known(base, dough),
    !,
    dough_questions.

continue_from_base :-
    known(base, meat),
    !,
    meat_questions.

continue_from_base :-
    true.


% 5. Rice dish question flow
% Narrow down between Congee, Sushi, Nasi Lemak, and Nasi Goreng

rice_questions :-
    ask_rice_style,
    continue_from_rice_style,
    continue_rice_identification.

% Congee: no additional questions needed
continue_from_rice_style :-
    known(rice_style, porridge),
    !.

% Sushi: ask about seasoned rice toppings
continue_from_rice_style :-
    known(rice_style, seasoned),
    !,
    ask_seasoned_rice_toppings.

% Rice that is neither porridge nor seasoned rice:
% check Nasi Lemak characteristics first
continue_from_rice_style :-
    known(rice_style, neither),
    !,
    ask_coconut_milk,
    ask_sambal.

% If the rice style is unknown, collect additional clues
continue_from_rice_style :-
    known(rice_style, unknown),
    !,
    ask_coconut_milk,
    ask_sambal,
    ask_seasoned_rice_toppings.

% If coconut milk and sambal are both confirmed, Nasi Lemak has enough evidence
continue_rice_identification :-
    known(coconut_milk, yes),
    known(sambal, yes),
    !.

% If sushi toppings are confirmed, stop before asking fried rice questions
continue_rice_identification :-
    known(seasoned_rice_with_toppings, yes),
    !.

% Otherwise, check whether it could be Nasi Goreng
continue_rice_identification :-
    ( known(rice_style, neither)
    ; known(rice_style, unknown)
    ),
    !,
    ask_method,
    continue_fried_rice_question.

continue_rice_identification :-
    true.

% Only ask about fried-rice ingredients if the cooking method is fried
continue_fried_rice_question :-
    known(method, fried),
    !,
    ask_fried_rice_ingredients.

continue_fried_rice_question :-
    true.


% 6. Noodle dish question flow
% Narrow down between Char Kway Teow (fried), Asam Laksa (sour fish broth), and Ramen (Japanese broth)

noodle_questions :-
    ask_method,
    continue_from_noodle_method.

% Fried noodles
continue_from_noodle_method :-
    known(method, fried),
    !,
    ask_flat_rice_noodles.

% Noodles served in broth
continue_from_noodle_method :-
    known(method, broth),
    !,
    ask_sour_fish_broth,
    continue_from_sour_fish_broth.

continue_from_noodle_method :-
    true.

% If sour fish broth is confirmed, skip the Japanese broth question
continue_from_sour_fish_broth :-
    known(sour_fish_broth, yes),
    !.

continue_from_sour_fish_broth :-
    ask_japanese_style_broth.


% 7. Dough dish question flow
% Check whether the dough is filled and how it is cooked (Steamed Dumplings)

dough_questions :-
    ask_filled_dough,
    continue_from_dough_filling.

% Only ask cooking method if filled dough is confirmed or unknown
continue_from_dough_filling :-
    \+ known(filled_dough, no),
    !,
    ask_method.

continue_from_dough_filling :-
    true.


% 8. Meat dish question flow
% Check grilling, skewers, dipping sauce, and seasoning (Satay)

meat_questions :-
    ask_method,
    continue_from_meat_method.

continue_from_meat_method :-
    known(method, grilled),
    !,
    ask_skewers,
    continue_from_skewers.

continue_from_meat_method :-
    true.

% Only ask about sauce if the food is served on skewers
continue_from_skewers :-
    known(skewers, yes),
    !,
    ask_dipping_sauce,
    continue_from_dipping_sauce.

continue_from_skewers :-
    true.

% If dipping sauce is confirmed, Satay is satisfied; otherwise ask if meat is seasoned
continue_from_dipping_sauce :-
    known(dipping_sauce, yes),
    !.

continue_from_dipping_sauce :-
    ask_seasoned_meat.


% 9. Main base question
% Ask for the primary ingredient of the dish (skip if already answered)

ask_base :-
    known(base, _),
    !.

ask_base :-
    nl,
    writeln('What is the main base of the dish?'),
    writeln('1. Rice'),
    writeln('2. Noodles'),
    writeln('3. Dough'),
    writeln('4. Meat'),
    write('Enter your choice: '),
    read(Choice),
    base_choice(Choice, Base),
    !,
    assertz(known(base, Base)),
    format('Recorded: main base = ~w~n', [Base]).

% Retry on invalid input
ask_base :-
    writeln('Invalid choice. Please enter 1, 2, 3 or 4.'),
    ask_base.

base_choice(1, rice).
base_choice(2, noodles).
base_choice(3, dough).
base_choice(4, meat).


% 10. Cooking method question
% Ask how the dish is prepared; if broth is chosen, also record has_broth = yes

ask_method :-
    known(method, _),
    !.

ask_method :-
    nl,
    writeln('How is the dish mainly prepared?'),
    writeln('1. Fried'),
    writeln('2. Steamed'),
    writeln('3. Grilled'),
    writeln('4. Served in broth'),
    write('Enter your choice: '),
    read(Choice),
    method_choice(Choice, Method),
    !,
    assertz(known(method, Method)),
    (
        Method = broth
    ->
        assertz(known(has_broth, yes))
    ;
        true
    ),
    format('Recorded: cooking method = ~w~n', [Method]).

% Retry on invalid input
ask_method :-
    writeln('Invalid choice. Please enter 1, 2, 3 or 4.'),
    ask_method.

method_choice(1, fried).
method_choice(2, steamed).
method_choice(3, grilled).
method_choice(4, broth).


% 11. Generic yes / no / unknown question helper
% Reusable prompt that stores yes, no, or unknown under known(Key, Answer)

ask_characteristic(Key, _Question) :-
    known(Key, _),
    !.

ask_characteristic(Key, Question) :-
    nl,
    writeln(Question),
    writeln('1. Yes'),
    writeln('2. No'),
    writeln('3. Unknown'),
    write('Enter your choice: '),
    read(Choice),
    yes_no_unknown(Choice, Answer),
    !,
    assertz(known(Key, Answer)),
    format('Recorded: ~w = ~w~n', [Key, Answer]).

% Retry on invalid input
ask_characteristic(Key, Question) :-
    writeln('Invalid choice. Please enter 1, 2 or 3.'),
    ask_characteristic(Key, Question).

yes_no_unknown(1, yes).
yes_no_unknown(2, no).
yes_no_unknown(3, unknown).


% 12. Coconut milk question (Nasi Lemak)

ask_coconut_milk :-
    ask_characteristic(
        coconut_milk,
        'Does the dish contain coconut milk?'
    ).


% 13. Sambal question (Nasi Lemak)

ask_sambal :-
    ask_characteristic(
        sambal,
        'Is the dish served with sambal?'
    ).


% 14. Broth question

ask_broth :-
    known(has_broth, _),
    !.

ask_broth :-
    ask_characteristic(
        has_broth,
        'Is the dish served with soup or broth?'
    ).


% 15. Sour fish broth question (Asam Laksa)

ask_sour_fish_broth :-
    ask_characteristic(
        sour_fish_broth,
        'Is the broth sour and fish-based?'
    ).


% 16. Japanese-style broth question (Ramen)

ask_japanese_style_broth :-
    ask_characteristic(
        japanese_style_broth,
        'Is it a Japanese-style noodle dish with Japanese-style broth?'
    ).


% 17. Filled dough question (Steamed Dumplings)

ask_filled_dough :-
    ask_characteristic(
        filled_dough,
        'Does the dish contain a filling wrapped in dough?'
    ).


% 18. Skewers question (Satay)

ask_skewers :-
    ask_characteristic(
        skewers,
        'Is the food served on skewers?'
    ).


% 19. Dipping sauce question (Satay)

ask_dipping_sauce :-
    ask_characteristic(
        dipping_sauce,
        'Is the food served with a dipping sauce?'
    ).


% 20. Flat rice noodles question (Char Kway Teow)

ask_flat_rice_noodles :-
    ask_characteristic(
        flat_rice_noodles,
        'Are the noodles flat rice noodles?'
    ).


% 21. Seasoned rice and toppings question (Sushi)

ask_seasoned_rice_toppings :-
    ask_characteristic(
        seasoned_rice_with_toppings,
        'Is the seasoned rice combined with fish or vegetables?'
    ).


% 22. Seasoned meat question (Satay fallback)

ask_seasoned_meat :-
    ask_characteristic(
        seasoned_meat,
        'Is the meat seasoned or marinated before grilling?'
    ).


% 23. Rice style question
% Distinguish between porridge (Congee), seasoned rice (Sushi), or other rice dishes

ask_rice_style :-
    known(rice_style, _),
    !.

ask_rice_style :-
    nl,
    writeln('What type of rice is it?'),
    writeln('1. Soft or porridge-like'),
    writeln('2. Seasoned rice'),
    writeln('3. Neither'),
    writeln('4. Unknown'),
    write('Enter your choice: '),
    read(Choice),
    rice_style_choice(Choice, Style),
    !,
    assertz(known(rice_style, Style)),
    format('Recorded: rice style = ~w~n', [Style]).

% Retry on invalid input
ask_rice_style :-
    writeln('Invalid choice. Please enter 1, 2, 3 or 4.'),
    ask_rice_style.

rice_style_choice(1, porridge).
rice_style_choice(2, seasoned).
rice_style_choice(3, neither).
rice_style_choice(4, unknown).


% 24. Fried rice ingredients question (Nasi Goreng)

ask_fried_rice_ingredients :-
    ask_characteristic(
        fried_rice_ingredients,
        'Is the rice stir-fried with seasonings and ingredients such as egg or vegetables?'
    ).


% 25. Find the result
% Collect all matching dishes and only accept a unique match

find_result(Dish) :-
    findall(D, identify(D), Dishes),
    sort(Dishes, UniqueDishes),
    choose_result(UniqueDishes, Dish).

% Succeeds with a dish only when exactly one unique dish matches; otherwise cannot_determine
choose_result([Dish], Dish).
choose_result([], cannot_determine).
choose_result([_,_|_], cannot_determine).


% 26. Finish identification
% Print the identified dish (or cannot_determine) and explain the reasoning

finish_identification :-
    find_result(Dish),
    nl,
    writeln('=================================================='),
    display_result(Dish),
    writeln('=================================================='),
    nl,
    explain(Dish).

display_result(nasi_lemak) :-
    writeln('Result: NASI LEMAK').

display_result(nasi_goreng) :-
    writeln('Result: NASI GORENG').

display_result(char_kway_teow) :-
    writeln('Result: CHAR KWAY TEOW').

display_result(asam_laksa) :-
    writeln('Result: ASAM LAKSA').

display_result(ramen) :-
    writeln('Result: RAMEN').

display_result(congee) :-
    writeln('Result: CONGEE').

display_result(steamed_dumplings) :-
    writeln('Result: STEAMED DUMPLINGS').

display_result(sushi) :-
    writeln('Result: SUSHI').

display_result(satay) :-
    writeln('Result: SATAY').

display_result(cannot_determine) :-
    writeln('Result: CANNOT DETERMINE').


% 27. Explanation
% Print the confirmed evidence that led to the identified dish (or why it failed)

explain(nasi_lemak) :-
    writeln('Why?'),
    explain_fact(
        base,
        rice,
        'The main base was identified as rice.'
    ),
    explain_fact(
        coconut_milk,
        yes,
        'The dish was confirmed to contain coconut milk.'
    ),
    explain_fact(
        sambal,
        yes,
        'The dish was confirmed to be served with sambal.'
    ),
    writeln('These characteristics satisfy the Nasi Lemak rule.').

explain(nasi_goreng) :-
    writeln('Why?'),
    explain_fact(base, rice, 'The main base was identified as rice.'),
    explain_fact(method, fried, 'The rice was confirmed to be fried.'),
    explain_fact(
        fried_rice_ingredients,
        yes,
        'The rice was confirmed to be stir-fried with seasonings and ingredients.'
    ),
    writeln('These characteristics satisfy the Nasi Goreng rule.').

explain(char_kway_teow) :-
    writeln('Why?'),
    explain_fact(
        base,
        noodles,
        'The main base was identified as noodles.'
    ),
    explain_fact(
        method,
        fried,
        'The dish was confirmed to be fried.'
    ),
    explain_fact(
        flat_rice_noodles,
        yes,
        'The noodles were confirmed to be flat rice noodles.'
    ),
    writeln('These characteristics satisfy the Char Kway Teow rule.').

explain(asam_laksa) :-
    writeln('Why?'),
    explain_fact(
        base,
        noodles,
        'The main base was identified as noodles.'
    ),
    explain_fact(
        method,
        broth,
        'The dish was identified as a broth-based dish.'
    ),
    explain_fact(
        sour_fish_broth,
        yes,
        'The broth was confirmed to be sour and fish-based.'
    ),
    writeln('These characteristics satisfy the Asam Laksa rule.').

explain(ramen) :-
    writeln('Why?'),
    explain_fact(
        base,
        noodles,
        'The main base was identified as noodles.'
    ),
    explain_fact(
        method,
        broth,
        'The dish was identified as a broth-based dish.'
    ),
    explain_fact(
        japanese_style_broth,
        yes,
        'The broth was identified as Japanese-style.'
    ),
    writeln('These characteristics satisfy the Ramen rule.').

explain(congee) :-
    writeln('Why?'),
    explain_fact(
        base,
        rice,
        'The main base was identified as rice.'
    ),
    explain_fact(
        rice_style,
        porridge,
        'The rice was identified as soft and porridge-like.'
    ),
    writeln('These characteristics satisfy the Congee rule.').

explain(steamed_dumplings) :-
    writeln('Why?'),
    explain_fact(
        base,
        dough,
        'The main base was identified as dough.'
    ),
    explain_fact(
        filled_dough,
        yes,
        'The dough was confirmed to contain a filling.'
    ),
    explain_fact(
        method,
        steamed,
        'The dish was confirmed to be steamed.'
    ),
    writeln('These characteristics satisfy the Steamed Dumplings rule.').

explain(sushi) :-
    writeln('Why?'),
    explain_fact(
        base,
        rice,
        'The main base was identified as rice.'
    ),
    explain_fact(
        rice_style,
        seasoned,
        'The rice was identified as seasoned rice.'
    ),
    explain_fact(
        seasoned_rice_with_toppings,
        yes,
        'The seasoned rice was confirmed to contain fish or vegetables.'
    ),
    writeln('These characteristics satisfy the Sushi rule.').

explain(satay) :-
    writeln('Why?'),
    explain_fact(
        base,
        meat,
        'The main base was identified as meat.'
    ),
    explain_fact(
        method,
        grilled,
        'The meat was confirmed to be grilled.'
    ),
    explain_fact(
        skewers,
        yes,
        'The food was confirmed to be served on skewers.'
    ),
    explain_fact(
        dipping_sauce,
        yes,
        'The food was confirmed to be served with a dipping sauce.'
    ),
    explain_fact(
        seasoned_meat,
        yes,
        'The meat was confirmed to be seasoned or marinated before grilling.'
    ),
    writeln('These characteristics satisfy the Satay rule.').

explain(cannot_determine) :-
    writeln('Why?'),
    writeln(
        '- The available characteristics do not sufficiently'
    ),
    writeln(
        '  match one of the nine supported dishes.'
    ),
    writeln(
        '- The system will not make an unsupported guess.'
    ),
    writeln(
        '- More information may be required, or the dish may'
    ),
    writeln(
        '  not be included in the knowledge base.'
    ),
    nl,
    writeln('Stored information checked:'),
    show_answers.


% 28. Evidence-based explanation helper
% Print Message only if known(Key, Value) was confirmed; otherwise succeed silently

explain_fact(Key, Value, Message) :-
    known(Key, Value),
    !,
    format('- ~w~n', [Message]).

explain_fact(_, _, _).


% 29. Display stored answers
% Print every known(Key, Value) fact recorded during the session

show_answers :-
    forall(
        known(Key, Value),
        format('- ~w = ~w~n', [Key, Value])
    ).
