--vendors
INSERT INTO vendors (supplier_name) VALUES
('Helical International'),
('Plates R Us'),
('Wholey Rollers'),
('Jack Daniels Belts'),
('Engine Accessories'),
('Comp USA'),
('Unharnessed at Large'),
('Get a Grip'),
('Telegraph Inc.'),
('Radio Shack'),
('Starbucks'),
('Michaels'),
('OSH');

--Piece Parts
INSERT INTO parts (part_number, part_name) VALUES
('1.1.1.1', 'Springs'),
('1.1.1.2', 'Torque'),
('1.1.2.1', 'Rollers'),
('1.1.3',   'Belt'),
('1.2.1',   'Pistons'),
('1.2.2',   'Rings'),
('1.3.1',   'ECU'),
('1.3.2.1.1', 'Stator Wiring'),
('2.1.1',   'Grips'),
('2.1.2.1', 'Cables'),
('2.1.3',   'Kill Switch'),
('2.2.1',   'Foam'),
('2.2.2',   'Fabric'),
('2.3.1',   'Bulb'),
('2.3.2',   'Headlight Wiring');


INSERT INTO piece_parts (piece_part_name, vendors_supplier_name) VALUES
('Springs', 'Helical International'),
('Torque', 'Plates R Us'),
('Rollers', 'Wholey Rollers'),
('Belt', 'Jack Daniels Belts'),
('Pistons', 'Engine Accessories'),
('Rings', 'Engine Accessories'),
('ECU', 'Comp USA'),
('Stator Wiring', 'Unharnessed at Large'),
('Grips', 'Get a Grip'),
('Cables', 'Telegraph Inc.'),
('Kill Switch', 'Radio Shack'),
('Foam', 'Starbucks'),
('Fabric', 'Michaels'),
('Bulb', 'OSH'),
('Headlight Wiring', 'Unharnessed at Large');


-- assemblies

INSERT INTO parts (part_number, part_name) VALUES
('1', 'Engine'),
('1.1', 'Transmission'),
('1.1.1', 'Clutch'),
('1.1.2', 'Variator'),
('1.2', 'Head'),
('1.3', 'Battery'),
('1.3.2', 'Starter'),
('1.3.2.1', 'Stator'),
('2', 'Frame'),
('2.1', 'Handlebars'),
('2.1.2', 'Throttle'),
('2.2', 'Seat'),
('2.3', 'Headlight'),
('0',  'Motorcycle');


INSERT INTO assembly_parts (assembly_part_name) VALUES
('Engine'),
('Transmission'),
('Clutch'),
('Variator'),
('Head'),
('Battery'),
('Starter'),
('Stator'),
('Frame'),
('Handlebars'),
('Throttle'),
('Seat'),
('Headlight'),
('Motorcycle');

INSERT INTO usages (assembly_parts_part_name, component_part_name, usage_quantity) VALUES
-- Engine
('Engine', 'Transmission', 1),
('Engine', 'Head', 2),
('Engine', 'Battery', 1),

-- Transmission
('Transmission', 'Clutch', 1),
('Transmission', 'Variator', 1),
('Transmission', 'Belt', 1),

-- Clutch
('Clutch', 'Springs', 4),
('Clutch', 'Torque', 1),

-- Variator
('Variator', 'Rollers', 5),

-- Head
('Head', 'Pistons', 2),
('Head', 'Rings', 2),

-- Battery
('Battery', 'ECU', 1),
('Battery', 'Starter', 1),

-- Starter
('Starter', 'Stator', 1),

-- Stator
('Stator', 'Stator Wiring', 1),

-- Frame
('Frame', 'Handlebars', 1),
('Frame', 'Seat', 1),
('Frame', 'Headlight', 1),

-- Handlebars
('Handlebars', 'Grips', 2),
('Handlebars', 'Throttle', 1),
('Handlebars', 'Kill Switch', 1),

-- Throttle
('Throttle', 'Cables', 1),

-- Seat
('Seat', 'Foam', 1),
('Seat', 'Fabric', 1),

-- Headlight
('Headlight', 'Bulb', 1),
('Headlight', 'Headlight Wiring', 1),

--Motorcycle
('Motorcycle', 'Engine', 1),
('Motorcycle', 'Frame', 1);

