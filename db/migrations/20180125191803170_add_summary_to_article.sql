-- +micrate Up
ALTER TABLE articles ADD COLUMN summary VARCHAR;
-- SQL in section 'Up' is executed when this migration is applied

-- +micrate Down
ALTER TABLE articles DROP COLUMN summary;
-- SQL section 'Down' is executed when this migration is rolled back
