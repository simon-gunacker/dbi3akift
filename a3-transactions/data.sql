INSERT INTO artikel VALUES 
(1, 'Arduino Uno', 'Mikrocontroller', 15.00, 25.00, 100, 10),
(2, 'Raspberry Pi 4', 'Mikrocontroller', 45.00, 75.00, 50, 5),
(3, 'LED 5mm rot', 'LED', 0.10, 0.25, 1000, 50),
(4, 'Widerstand 220Ω', 'Widerstand', 0.02, 0.05, 5000, 100),
(5, 'Breadboard', 'Zubehör', 3.00, 8.00, 30, 5);

INSERT INTO kunde VALUES 
(1, 'TechShop Wien', 5000.00, 1200.00),
(2, 'MakerSpace Graz', 2000.00, 0.00),
(3, 'Elektronik Steiner', 10000.00, 3500.00);


INSERT INTO lagerbewegung (id, artikel_id, menge, typ)
VALUES (-1, 1, 100, 'erstlieferung');

INSERT INTO lagerbewegung (id, artikel_id, menge, typ)
VALUES (-2, 2, 50, 'erstlieferung');

INSERT INTO lagerbewegung (id, artikel_id, menge, typ)
VALUES (-3, 3, 1000, 'erstlieferung');

INSERT INTO lagerbewegung (id, artikel_id, menge, typ)
VALUES (-4, 4, 5000, 'erstlieferung');

INSERT INTO lagerbewegung (id, artikel_id, menge, typ)
VALUES (-5, 5, 30, 'erstlieferung');