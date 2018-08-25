DELIMITER $$
CREATE PROCEDURE `GetMeals` (IN `userId` INT, IN `mealsDay` DATE)  BEGIN
    SELECT mety.mety_name AS `meal-type`, al.al_id AS `id`, al.al_name AS `name`, meal.quantity AS `quantity`, 
        un.un_name AS `unit`, ROUND((((al.al_hydrates * meal.quantity * alun.grams_per_unit) / 100) * 4) +
        (((al.al_proteins * meal.quantity * alun.grams_per_unit) / 100) * 4) + 
        (((al.al_fat * meal.quantity * alun.grams_per_unit) / 100) * 9)) AS `calories` 
        FROM MEAL_TYPE mety
            INNER JOIN MEAL me ON me.mety_id = mety.mety_id
            INNER JOIN MEAL_ALIMENT meal ON meal.me_id = me.me_id
            INNER JOIN UNIT un ON un.un_id = meal.un_id 
            INNER JOIN ALIMENT al ON al.al_id = meal.al_id
            INNER JOIN ALIMENT_UNIT alun ON alun.al_id = al.al_id AND alun.un_id = meal.un_id
        WHERE me.us_id = userId AND me.me_date = mealsDay
    UNION
    SELECT mety.mety_name AS `meal-type`, re.re_id AS `id`, re.re_name AS `name`, NULL AS `quantity`, NULL AS `unit`, 
        ROUND(SUM((((al.al_hydrates * ral.quantity * alun.grams_per_unit) / 100) * 4) +
        (((al.al_proteins * ral.quantity * alun.grams_per_unit) / 100) * 4) +
        (((al.al_fat * ral.quantity * alun.grams_per_unit) / 100) * 9))) AS `calories`
        FROM MEAL_TYPE mety
            INNER JOIN MEAL me ON me.mety_id = mety.mety_id
            INNER JOIN MEAL_RECIPE mere ON mere.me_id = me.me_id
            INNER JOIN RECIPE re ON re.re_id = mere.re_id
            INNER JOIN RECIPE_ALIMENT ral ON ral.re_id = re.re_id
            INNER JOIN ALIMENT al ON al.al_id = ral.al_id
            INNER JOIN ALIMENT_UNIT alun ON alun.al_id = al.al_id AND alun.un_id = ral.un_id
        WHERE me.us_id = userId AND me.me_date = mealsDay
            GROUP BY re.re_id
    ORDER BY `name` ASC;
END$$
DELIMITER ;