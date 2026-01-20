-- DDL & insert statements only

-- tables
-- Table: assemblies
CREATE TABLE assemblies (
    assembly_part_number VARCHAR(20)  NOT NULL,
    CONSTRAINT assemblies_pk PRIMARY KEY (assembly_part_number)
);

-- Table: part_usages
CREATE TABLE part_usages (
    assembly_parts_number VARCHAR(20)  NOT NULL,
    sub_assembly_parts_number VARCHAR(20)  NOT NULL,
    quantity int  NOT NULL,
    CONSTRAINT part_usages_pk PRIMARY KEY (sub_assembly_parts_number,assembly_parts_number)
);

-- Table: parts
CREATE TABLE parts (
    number VARCHAR(20)  NOT NULL,
    name VARCHAR(80)  NOT NULL,
    CONSTRAINT parts_pk PRIMARY KEY (number)
);

-- Table: piece_parts
CREATE TABLE piece_parts (
    piece_part_number VARCHAR(20)  NOT NULL,
    supplier VARCHAR(80)  NOT NULL,
    CONSTRAINT piece_parts_pk PRIMARY KEY (piece_part_number)
);

-- foreign keys
-- Reference: assemblies_parts_fk_01 (table: assemblies)
ALTER TABLE assemblies ADD CONSTRAINT assemblies_parts_fk_01
    FOREIGN KEY (assembly_part_number)
    REFERENCES parts (number)
    ON DELETE  RESTRICT
    ON UPDATE  RESTRICT
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: part_usages_assemblies_fk_01 (table: part_usages)
ALTER TABLE part_usages ADD CONSTRAINT part_usages_assemblies_fk_01
    FOREIGN KEY (assembly_parts_number)
    REFERENCES assemblies (assembly_part_number)
    ON DELETE  RESTRICT
    ON UPDATE  RESTRICT
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: part_usages_parts_fk_01 (table: part_usages)
ALTER TABLE part_usages ADD CONSTRAINT part_usages_parts_fk_01
    FOREIGN KEY (sub_assembly_parts_number)
    REFERENCES parts (number)
    ON DELETE  RESTRICT
    ON UPDATE  RESTRICT
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: piece_parts_parts (table: piece_parts)
ALTER TABLE piece_parts ADD CONSTRAINT piece_parts_parts
    FOREIGN KEY (piece_part_number)
    REFERENCES parts (number)
    ON DELETE  RESTRICT
    ON UPDATE  RESTRICT
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- End of file.


INSERT INTO parts(number, name)
VALUES      ('0', 'motorcycle'),
            ('1', 'engine'),
            ('1.1', 'transmission'),
            ('1.1.1', 'clutch'),
            ('1.1.1.1', 'springs'),
            ('1.1.1.2', 'torque plate'),
            ('1.1.2', 'variator'),
            ('1.1.2.1', 'rollers'),
            ('1.1.3', 'belt'),
            ('1.2', 'head'),
            ('1.2.1', 'pistons'),
            ('1.2.2', 'rings'),
            ('1.3', 'battery'),
            ('1.3.1', 'ECU'),
            ('1.3.2', 'starter'),
            ('1.3.2.1', 'stator'),
            ('1.3.2.1.1', 'wiring');

-- DELETE FROM parts;

INSERT INTO assemblies (assembly_part_number)
VALUES ('0'), ('1'), ('1.1'), ('1.1.1'), ('1.1.2'), ('1.2'), ('1.3'), ('1.3.2'), ('1.3.2.1');

INSERT INTO piece_parts (piece_part_number, supplier)
VALUES ('1.1.1.1', 'Joyce Springs & Co'),
        ('1.1.1.2', 'Fred''s clutches'),
        ('1.1.2.1', 'Rollerdrome'),
        ('1.1.3', 'A stiff one'),
        ('1.2.1', 'Houston Pistons'),
        ('1.2.2', 'Wedding rings'),
        ('1.3.1', 'Cory''s controls'),
        ('1.3.2.1.1', 'Wierd Al''s Wiring');

-- DELETE FROM part_usages;

INSERT INTO part_usages(assembly_parts_number, sub_assembly_parts_number, quantity)
VALUES ('0', '1', 1),
        ('1', '1.1', 1),
        ('1.1', '1.1.1', 1),
        ('1.1.1', '1.1.1.1', 4),
        ('1.1.1', '1.1.1.2', 1),
        ('1.1.2', '1.1.2.1', 5),
        ('1.1', '1.1.2', 1),
        ('1.1', '1.1.3', 1),
        ('1', '1.2', 2),
        ('1.2', '1.2.1', 2),
        ('1.2', '1.2.2', 2),
        ('1', '1.3', 1),
        ('1.3', '1.3.1', 1),
        ('1.3', '1.3.2', 1),
        ('1.3.2', '1.3.2.1', 1),
        ('1.3.2.1', '1.3.2.1.1', 1);
