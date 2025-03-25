-- creating first user and assigning it admin role
INSERT INTO wp_users (user_login, user_pass, user_registered)
VALUES ('amakela', MD5('pswd123'), NOW());

INSERT INTO wp_usermeta (user_id, meta_key, meta_value)
VALUES (LAST_INSERT_ID(), 'wp_capabilities', 'a:1:{s:13:"administrator";b:1;}');

-- creating second user and assigning it editor role
INSERT INTO wp_users (user_login, user_pass, user_registered)
VALUES ('another-user', MD5('pswd321'), NOW());

INSERT INTO wp_usermeta (user_id, meta_key, meta_value)
VALUES (LAST_INSERT_ID(), 'wp_capabilities', 'a:1:{s:6:"editor";b:1;}');

