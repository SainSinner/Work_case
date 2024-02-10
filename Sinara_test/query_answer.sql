-- ОБЩИЙ ЗАПРОС_СОРТИРОВАННЫЙ
SELECT *
FROM (SELECT c.fst_name,
             c.mid_name,
             c.last_name,
             c.x_gb_status,
             p.addr,
             a.created,
             a.con_id,
             a.stat,
             a.todo_cd,
             a.comments_long
      FROM sinara.activity a
               LEFT JOIN sinara.contact c on a.con_id = c.row_id
               LEFT JOIN (SELECT *
                          FROM sinara.per_addr
                          WHERE comm_medium_cd = 'Email') p on a.con_id = p.per_id
      WHERE a.created = (SELECT MAX(created)
                         FROM sinara.activity
                         WHERE todo_cd = 'Электронная почта'
                           AND sinara.activity.con_id = a.con_id
                         GROUP BY con_id)

      UNION

      SELECT c.fst_name,
             c.mid_name,
             c.last_name,
             c.x_gb_status,
             p.addr,
             a.created,
             a.con_id,
             a.stat,
             a.todo_cd,
             a.comments_long
      FROM sinara.activity a
               LEFT JOIN sinara.contact c on a.con_id = c.row_id
               LEFT JOIN (SELECT *
                          FROM sinara.per_addr
                          -- Оставили только мобильные телефоны
                          WHERE comm_medium_cd = 'Phone'
                            AND addr NOT LIKE '734%') p on a.con_id = p.per_id
      WHERE a.created = (SELECT MAX(created)
                         FROM sinara.activity
                         WHERE todo_cd = 'СМС'
                           AND activity.stat = 'Доставлено'
                           AND sinara.activity.con_id = a.con_id
                         GROUP BY con_id)
      GROUP BY c.fst_name,
               c.mid_name,
               c.last_name,
               c.x_gb_status,
               p.addr,
               a.created,
               a.con_id,
               a.stat,
               a.todo_cd,
               a.comments_long

      UNION

      SELECT c.fst_name,
             c.mid_name,
             c.last_name,
             c.x_gb_status,
             p.addr,
             a.created,
             a.con_id,
             a.stat,
             a.todo_cd,
             a.comments_long
      FROM sinara.activity a
               LEFT JOIN sinara.contact c on a.con_id = c.row_id
               LEFT JOIN (SELECT *
                          FROM sinara.per_addr
                          -- Оставили только мобильные телефоны
                          WHERE comm_medium_cd = 'Phone'
                            AND addr NOT LIKE '734%') p on a.con_id = p.per_id
      WHERE a.created = (SELECT MAX(created)
                         FROM sinara.activity
                         WHERE comments_long != ''
                           AND todo_cd = 'Вызов - исходящий из кампании'
                           -- Отсеили дозвон по недейтсительному номеру
                           AND stat != 'Неверный номер'
                           AND sinara.activity.con_id = a.con_id
                         GROUP BY con_id)
      GROUP BY c.fst_name,
               c.mid_name,
               c.last_name,
               c.x_gb_status,
               p.addr,
               a.created,
               a.con_id,
               a.stat,
               a.todo_cd,
               a.comments_long)
ORDER BY con_id, todo_cd;