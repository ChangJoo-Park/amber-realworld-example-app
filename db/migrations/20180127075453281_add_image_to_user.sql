-- +micrate Up
ALTER TABLE users ADD COLUMN profile_image VARCHAR;
-- SQL in section 'Up' is executed when this migration is applied

-- +micrate Down
ALTER TABLE users DROP COLUMN profile_image;
-- SQL section 'Down' is executed when this migration is rolled back
