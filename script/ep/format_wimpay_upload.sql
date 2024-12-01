SELECT
    l.sysid,
    CONCAT(
        DATE_FORMAT(STR_TO_DATE(w.DateTransaction, '%d/%m/%Y'), '%Y/%m/%d'),
        ' ',
        w.HeureTransaction
    ) AS formatted_datetime,
    w.ReferTransaction,
    l.code_antenne
FROM
    wimpay w
JOIN
    locataire l
ON
    SUBSTRING_INDEX(w.Libelle, '_', 1) = l.code_benifis
