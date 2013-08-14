# Any SQL files included in the database/backups directory will be
# imported as Vagrant boots up. To best manage expectations, these
# databases should be created in advance with proper user permissions
# so that any code bases configured to work with them will start
# without trouble.
#
# Add any additional SQL commands that should run on startup. Most likely
# these will be similar to the following - with CREATE DATABASE and GRANT ALL,
# but it can be any command.
#
CREATE DATABASE IF NOT EXISTS `411`;
GRANT ALL PRIVILEGES ON `411`.* TO 'wp'@'localhost' IDENTIFIED BY 'wp';

CREATE DATABASE IF NOT EXISTS `awardsline`;
GRANT ALL PRIVILEGES ON `awardsline`.* TO 'wp'@'localhost' IDENTIFIED BY 'wp';

CREATE DATABASE IF NOT EXISTS `bgr`;
GRANT ALL PRIVILEGES ON `bgr`.* TO 'wp'@'localhost' IDENTIFIED BY 'wp';

CREATE DATABASE IF NOT EXISTS `deadline`;
GRANT ALL PRIVILEGES ON `deadline`.* TO 'wp'@'localhost' IDENTIFIED BY 'wp';

CREATE DATABASE IF NOT EXISTS `hollywoodlife`;
GRANT ALL PRIVILEGES ON `hollywoodlife`.* TO 'wp'@'localhost' IDENTIFIED BY 'wp';

CREATE DATABASE IF NOT EXISTS `tvline`;
GRANT ALL PRIVILEGES ON `tvline`.* TO 'wp'@'localhost' IDENTIFIED BY 'wp';

CREATE DATABASE IF NOT EXISTS `variety`;
GRANT ALL PRIVILEGES ON `variety`.* TO 'wp'@'localhost' IDENTIFIED BY 'wp';

# This should go last
FLUSH PRIVILEGES;