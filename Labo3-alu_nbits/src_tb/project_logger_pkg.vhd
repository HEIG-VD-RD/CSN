

use work.logger_pkg.all;

package project_logger_pkg is

    -- Simply exports a logger that can be used accross entities
    shared variable logger : logger_t;

end project_logger_pkg;
