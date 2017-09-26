/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.common.handler;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.ibatis.type.JdbcType;
import org.apache.ibatis.type.MappedTypes;
import org.apache.ibatis.type.TypeHandler;
import org.springframework.stereotype.Component;

import com.jaha.evote.domain.EncryptedString;

/**
 * <pre>
 * Class Name : EncryptedStringTypeHandler.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 11. 7.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 11. 7.
 * @version 1.0
 */
@Component
@MappedTypes(EncryptedString.class)
public class EncryptedStringTypeHandler implements TypeHandler<EncryptedString> {

    @Override
    public void setParameter(PreparedStatement ps, int i, EncryptedString parameter, JdbcType jdbcType) throws SQLException {
        if (parameter != null) {
            ps.setString(i, parameter.getValue());
        } else {
            ps.setNull(i, JdbcType.NULL.TYPE_CODE);
        }
    }

    @Override
    public EncryptedString getResult(ResultSet rs, String columnName) throws SQLException {
        return new EncryptedString(rs.getString(columnName));
    }

    @Override
    public EncryptedString getResult(ResultSet rs, int columnIndex) throws SQLException {
        return new EncryptedString(rs.getString(columnIndex));
    }

    @Override
    public EncryptedString getResult(CallableStatement cs, int columnIndex) throws SQLException {
        return new EncryptedString(cs.getString(columnIndex));
    }
}
