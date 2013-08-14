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
CREATE DATABASE IF NOT EXISTS `variety411_dev`;
GRANT ALL PRIVILEGES ON `variety411_dev`.* TO 'wp'@'localhost' IDENTIFIED BY 'wp';

CREATE DATABASE IF NOT EXISTS `awardsline_dev`;
GRANT ALL PRIVILEGES ON `awardsline_dev`.* TO 'wp'@'localhost' IDENTIFIED BY 'wp';

CREATE DATABASE IF NOT EXISTS `bgr_dev`;
GRANT ALL PRIVILEGES ON `bgr_dev`.* TO 'wp'@'localhost' IDENTIFIED BY 'wp';

CREATE DATABASE IF NOT EXISTS `deadline_dev`;
GRANT ALL PRIVILEGES ON `deadline_dev`.* TO 'wp'@'localhost' IDENTIFIED BY 'wp';

CREATE DATABASE IF NOT EXISTS `hollywoodlife_dev`;
GRANT ALL PRIVILEGES ON `hollywoodlife_dev`.* TO 'wp'@'localhost' IDENTIFIED BY 'wp';

CREATE DATABASE IF NOT EXISTS `tvline_dev`;
GRANT ALL PRIVILEGES ON `tvline_dev`.* TO 'wp'@'localhost' IDENTIFIED BY 'wp';

CREATE DATABASE IF NOT EXISTS `variety_dev`;
GRANT ALL PRIVILEGES ON `variety_dev`.* TO 'wp'@'localhost' IDENTIFIED BY 'wp';

# This should go last
FLUSH PRIVILEGES;