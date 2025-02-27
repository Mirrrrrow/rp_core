ALTER TABLE `owned_vehicles`
ADD COLUMN `vehicleId` INT NOT NULL;

ALTER TABLE owned_vehicles
DROP PRIMARY KEY,
ADD PRIMARY KEY (vehicleId);