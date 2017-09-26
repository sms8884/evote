package com.jaha.evote.common.formatter;

import net.sf.log4jdbc.Slf4jSpyLogDelegator;
import net.sf.log4jdbc.Spy;
import net.sf.log4jdbc.tools.LoggingType;

public class Log4JdbcFormatter extends Slf4jSpyLogDelegator {

    private LoggingType loggingType = LoggingType.DISABLED;

    private String margin = "";

    private String sqlPrefix = "SQL:";

    public int getMargin() {
        return margin.length();
    }

    public void setMargin(int n) {
        margin = String.format("%1$#" + n + "s", "");
    }

    public Log4JdbcFormatter() {}

    @Override
    public String sqlOccured(Spy spy, String methodCall, String rawSql) {
        if (loggingType == LoggingType.DISABLED) {
            return "";
        }

        // Remove all existing cr lf, unless MULTI_LINE
        if (loggingType != LoggingType.MULTI_LINE) {
            rawSql = rawSql.replaceAll("\r", "");
            rawSql = rawSql.replaceAll("\n", "");
        }
        final String fromClause = " from ";
        String sql = rawSql;
        if (loggingType == LoggingType.MULTI_LINE) {
            final String whereClause = " where ";
            final String andClause = " and ";
            final String subSelectClauseS = "\\(select";
            final String subSelectClauseR = " (select";
            sql = sql.replaceAll(fromClause, "\n" + margin + fromClause);
            sql = sql.replaceAll(whereClause, "\n" + margin + whereClause);
            sql = sql.replaceAll(andClause, "\n" + margin + andClause);
            sql = sql.replaceAll(subSelectClauseS, "\n" + margin + subSelectClauseR);
        }
        if (loggingType == LoggingType.SINGLE_LINE_TWO_COLUMNS) {
            if (sql.startsWith("select")) {
                String from = sql.substring(sql.indexOf(fromClause) + fromClause.length());
                sql = from + "\t" + sql;
            }
        }
        getSqlOnlyLogger().info(
                sqlPrefix + "\n" + "====================================================================================================\n" + " " + sql + "\n"
                        + "====================================================================================================");
        return sql;
    }

    @Override
    public String sqlOccured(Spy spy, String methodCall, String[] sqls) {
        String s = "";
        for (int i = 0; i < sqls.length; i++) {
            s += sqlOccured(spy, methodCall, sqls[i]) + String.format("%n");
        }
        return s;
    }

    public LoggingType getLoggingType() {
        return loggingType;
    }

    public void setLoggingType(LoggingType loggingType) {
        this.loggingType = loggingType;
    }

    public String getSqlPrefix() {
        return sqlPrefix;
    }

    public void setSqlPrefix(String sqlPrefix) {
        this.sqlPrefix = sqlPrefix;
    }

}
