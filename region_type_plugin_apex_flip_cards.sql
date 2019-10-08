prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_190100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2016.08.24'
,p_release=>'5.1.3.00.05'
,p_default_workspace_id=>21717127411908241868
,p_default_application_id=>103428
,p_default_owner=>'RD_DEV'
);
end;
/
prompt --application/shared_components/plugins/region_type/apex_flip_cards
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(91165580813989192805)
,p_plugin_type=>'REGION TYPE'
,p_name=>'APEX.FLIP.CARDS'
,p_display_name=>'APEX Flip Cards'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'FUNCTION SQL_TO_SYS_REFCURSOR (',
'    P_IN_SQL_STATEMENT   CLOB,',
'    P_IN_BINDS           SYS.DBMS_SQL.VARCHAR2_TABLE',
') RETURN SYS_REFCURSOR AS',
'    VR_CURS         BINARY_INTEGER;',
'    VR_REF_CURSOR   SYS_REFCURSOR;',
'    VR_EXEC         BINARY_INTEGER;',
'/* TODO make size dynamic */',
'    VR_BINDS        VARCHAR(100);',
'BEGIN',
'    VR_CURS         := DBMS_SQL.OPEN_CURSOR;',
'    DBMS_SQL.PARSE(',
'        VR_CURS,',
'        P_IN_SQL_STATEMENT,',
'        DBMS_SQL.NATIVE',
'    );',
'    IF P_IN_BINDS.COUNT > 0 THEN',
'        FOR I IN 1..P_IN_BINDS.COUNT LOOP',
'        /* TODO find out how to prevent ltrim */',
'            VR_BINDS   := LTRIM(',
'                P_IN_BINDS(I),',
'                '':''',
'            );',
'            DBMS_SQL.BIND_VARIABLE(',
'                VR_CURS,',
'                VR_BINDS,',
'                V(VR_BINDS)',
'            );',
'        END LOOP;',
'    END IF;',
'',
'    VR_EXEC         := DBMS_SQL.EXECUTE(VR_CURS);',
'    VR_REF_CURSOR   := DBMS_SQL.TO_REFCURSOR(VR_CURS);',
'    RETURN VR_REF_CURSOR;',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        IF DBMS_SQL.IS_OPEN(VR_CURS) THEN',
'            DBMS_SQL.CLOSE_CURSOR(VR_CURS);',
'        END IF;',
'        RAISE;',
'END;',
'',
'FUNCTION F_AJAX (',
'    P_REGION   IN         APEX_PLUGIN.T_REGION,',
'    P_PLUGIN   IN         APEX_PLUGIN.T_PLUGIN',
') RETURN APEX_PLUGIN.T_REGION_AJAX_RESULT IS',
'    VR_RESULT       APEX_PLUGIN.T_REGION_AJAX_RESULT;',
'    VR_CUR          SYS_REFCURSOR;',
'    VR_BIND_NAMES   SYS.DBMS_SQL.VARCHAR2_TABLE;',
'BEGIN',
'/* undocumented function of APEX for get all bindings */',
'    VR_BIND_NAMES   := WWV_FLOW_UTILITIES.GET_BINDS(P_REGION.SOURCE);',
'',
'/* execute binding*/',
'    VR_CUR          := SQL_TO_SYS_REFCURSOR(',
'        RTRIM(',
'            P_REGION.SOURCE,',
'            '';''',
'        ),',
'        VR_BIND_NAMES',
'    );',
'',
'/* create json */',
'    APEX_JSON.OPEN_OBJECT;',
'    APEX_JSON.WRITE(',
'        ''row'',',
'        VR_CUR',
'    );',
'    APEX_JSON.CLOSE_OBJECT;',
'',
'    RETURN VR_RESULT;',
'END;',
'',
'FUNCTION F_RENDER (',
'    P_REGION                IN                      APEX_PLUGIN.T_REGION,',
'    P_PLUGIN                IN                      APEX_PLUGIN.T_PLUGIN,',
'    P_IS_PRINTER_FRIENDLY   IN                      BOOLEAN',
') RETURN APEX_PLUGIN.T_REGION_RENDER_RESULT IS',
'',
'    VR_RESULT         APEX_PLUGIN.T_REGION_RENDER_RESULT;',
'    VR_ITEMS2SUBMIT   APEX_APPLICATION_PAGE_REGIONS.AJAX_ITEMS_TO_SUBMIT%TYPE := APEX_PLUGIN_UTIL.PAGE_ITEM_NAMES_TO_JQUERY(P_REGION.AJAX_ITEMS_TO_SUBMIT);',
'BEGIN',
'    APEX_CSS.ADD_FILE(',
'        P_NAME        => ''flipcards.pkgd.min'',',
'        P_DIRECTORY   => P_PLUGIN.FILE_PREFIX,',
'        P_VERSION     => NULL,',
'        P_KEY         => ''fccsssrc''',
'    );',
'',
'    APEX_JAVASCRIPT.ADD_LIBRARY(',
'        P_NAME        => ''flipcards.pkgd.min'',',
'        P_DIRECTORY   => P_PLUGIN.FILE_PREFIX,',
'        P_VERSION     => NULL,',
'        P_KEY         => ''fcjssrc''',
'    );',
'',
'    HTP.P(''<div id="'' || APEX_ESCAPE.HTML_ATTRIBUTE( P_REGION.STATIC_ID ) || ''-p" class="mat-flip-cards"></div>'');',
'',
'    APEX_JAVASCRIPT.ADD_ONLOAD_CODE( ''apexFlipCards.render(''',
'     || APEX_JAVASCRIPT.ADD_VALUE( P_REGION.STATIC_ID, TRUE )    ',
'     || APEX_JAVASCRIPT.ADD_VALUE( APEX_PLUGIN.GET_AJAX_IDENTIFIER, TRUE )',
'     || APEX_JAVASCRIPT.ADD_VALUE( P_REGION.NO_DATA_FOUND_MESSAGE, TRUE )',
'     || APEX_JAVASCRIPT.ADD_VALUE( VR_ITEMS2SUBMIT, TRUE )',
'     || APEX_JAVASCRIPT.ADD_VALUE( P_REGION.ESCAPE_OUTPUT, TRUE )',
'     || APEX_JAVASCRIPT.ADD_VALUE( P_REGION.ATTRIBUTE_01, FALSE )',
'     || '');'' );',
'',
'    RETURN VR_RESULT;',
'END;'))
,p_api_version=>1
,p_render_function=>'F_RENDER'
,p_ajax_function=>'F_AJAX'
,p_standard_attributes=>'SOURCE_SQL:AJAX_ITEMS_TO_SUBMIT:NO_DATA_FOUND_MESSAGE:ESCAPE_OUTPUT'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>'This plug-in is used to visualize flip Cards.'
,p_version_identifier=>'1.0.1'
,p_about_url=>'https://github.com/RonnyWeiss/APEX-Flip-Cards'
,p_files_version=>1534
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(36281043316184656151)
,p_plugin_id=>wwv_flow_api.id(91165580813989192805)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'ConfigJSON'
,p_attribute_type=>'JAVASCRIPT'
,p_is_required=>true
,p_default_value=>wwv_flow_string.join(wwv_flow_t_varchar2(
'{',
'  "cardWidth": 4,',
'  "refresh": 0',
'}'))
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>',
'{',
'  "cardWidth": 4,',
'  "refresh": 0',
'}',
'</pre>',
'<br>',
'<h3>Explanation:</h3>',
'  <dl>',
'  <dt>cardWidth (number)</dt>',
'  <dd>width per card between 1 and 12</dd>',
'  <dl>',
'  <dt>refresh (number)</dt>',
'  <dd>wrefresh time of cards in seconds if 0 then no refresh will be set</dd>'))
);
wwv_flow_api.create_plugin_std_attribute(
 p_id=>wwv_flow_api.id(36280891388975270238)
,p_plugin_id=>wwv_flow_api.id(91165580813989192805)
,p_name=>'SOURCE_SQL'
,p_default_value=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    /* title of the card */',
'    ''Image '' || ROWNUM AS TITLE,',
'    /* src link of the image */',
'    ''https://raw.githubusercontent.com/RonnyWeiss/Apex-Advent-Calendar/master/img/full/0'' ||',
'    ROWNUM || ''.jpg'' AS IMG_SRC,',
'    /* description */',
'    ''This is an example text.'' AS DESCRIPTION,',
'    /* Optional background color of the description */',
'    ''rgb(125,125,125)'' AS DESC_BACK_COLOR,',
'    /* Optional font color of the description */',
'    ''white'' AS DESC_FONT_COLOR',
'FROM',
'    DUAL',
'CONNECT BY',
'    ROWNUM <= 6'))
,p_sql_min_column_count=>1
,p_depending_on_has_to_exist=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>',
'SELECT',
'    /* title of the card */',
'    ''Image '' || ROWNUM AS TITLE,',
'    /* src link of the image */',
'    ''https://raw.githubusercontent.com/RonnyWeiss/Apex-Advent-Calendar/master/img/full/0'' ||',
'    ROWNUM || ''.jpg'' AS IMG_SRC,',
'    /* description */',
'    ''This is an example text.'' AS DESCRIPTION,',
'    /* Optional background color of the description */',
'    ''rgb(125,125,125)'' AS DESC_BACK_COLOR,',
'    /* Optional font color of the description */',
'    ''white'' AS DESC_FONT_COLOR',
'FROM',
'    DUAL',
'CONNECT BY',
'    ROWNUM <= 6',
'<pre>'))
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E666C69702D632D636F6E7461696E65727B77696474683A3938253B6D617267696E2D6C6566743A6175746F3B6D617267696E2D72696768743A6175746F7D2E666C69702D632D726F777B706F736974696F6E3A72656C61746976653B77696474683A31';
wwv_flow_api.g_varchar2_table(2) := '3030257D2E666C69702D632D726F77205B636C6173735E3D666C69702D632D636F6C5D7B666C6F61743A6C6566743B6D617267696E3A2E3572656D2032253B6D696E2D6865696768743A2E31323572656D7D2E666C69702D632D636F6C2D312C2E666C69';
wwv_flow_api.g_varchar2_table(3) := '702D632D636F6C2D31302C2E666C69702D632D636F6C2D31312C2E666C69702D632D636F6C2D31322C2E666C69702D632D636F6C2D322C2E666C69702D632D636F6C2D332C2E666C69702D632D636F6C2D342C2E666C69702D632D636F6C2D352C2E666C';
wwv_flow_api.g_varchar2_table(4) := '69702D632D636F6C2D362C2E666C69702D632D636F6C2D372C2E666C69702D632D636F6C2D382C2E666C69702D632D636F6C2D397B77696474683A3936257D2E666C69702D632D636F6C2D312D736D7B77696474683A342E3333257D2E666C69702D632D';
wwv_flow_api.g_varchar2_table(5) := '636F6C2D322D736D7B77696474683A31322E3636257D2E666C69702D632D636F6C2D332D736D7B77696474683A3231257D2E666C69702D632D636F6C2D342D736D7B77696474683A32392E3333257D2E666C69702D632D636F6C2D352D736D7B77696474';
wwv_flow_api.g_varchar2_table(6) := '683A33372E3636257D2E666C69702D632D636F6C2D362D736D7B77696474683A3436257D2E666C69702D632D636F6C2D372D736D7B77696474683A35342E3333257D2E666C69702D632D636F6C2D382D736D7B77696474683A36322E3636257D2E666C69';
wwv_flow_api.g_varchar2_table(7) := '702D632D636F6C2D392D736D7B77696474683A3731257D2E666C69702D632D636F6C2D31302D736D7B77696474683A37392E3333257D2E666C69702D632D636F6C2D31312D736D7B77696474683A38372E3636257D2E666C69702D632D636F6C2D31322D';
wwv_flow_api.g_varchar2_table(8) := '736D7B77696474683A3936257D2E666C69702D632D726F773A3A61667465727B636F6E74656E743A22223B646973706C61793A7461626C653B636C6561723A626F74687D2E68696464656E2D736D7B646973706C61793A6E6F6E657D406D65646961206F';
wwv_flow_api.g_varchar2_table(9) := '6E6C792073637265656E20616E6420286D696E2D77696474683A33332E3735656D297B2E666C69702D632D636F6E7461696E65727B77696474683A3938257D7D406D65646961206F6E6C792073637265656E20616E6420286D696E2D77696474683A3630';
wwv_flow_api.g_varchar2_table(10) := '656D297B2E666C69702D632D636F6C2D312C2E666C69702D632D636F6C2D322C2E666C69702D632D636F6C2D332C2E666C69702D632D636F6C2D342C2E666C69702D632D636F6C2D352C2E666C69702D632D636F6C2D367B77696474683A3436257D2E66';
wwv_flow_api.g_varchar2_table(11) := '6C69702D632D636F6C2D31302C2E666C69702D632D636F6C2D31312C2E666C69702D632D636F6C2D31322C2E666C69702D632D636F6C2D372C2E666C69702D632D636F6C2D382C2E666C69702D632D636F6C2D397B77696474683A3936257D2E68696464';
wwv_flow_api.g_varchar2_table(12) := '656E2D736D7B646973706C61793A626C6F636B7D7D406D65646961206F6E6C792073637265656E20616E6420286D696E2D77696474683A3636656D297B2E666C69702D632D636F6E7461696E65727B77696474683A3938257D2E666C69702D632D636F6C';
wwv_flow_api.g_varchar2_table(13) := '2D317B77696474683A342E3333257D2E666C69702D632D636F6C2D327B77696474683A31322E3636257D2E666C69702D632D636F6C2D337B77696474683A3231257D2E666C69702D632D636F6C2D347B77696474683A32392E3333257D2E666C69702D63';
wwv_flow_api.g_varchar2_table(14) := '2D636F6C2D357B77696474683A33372E3636257D2E666C69702D632D636F6C2D367B77696474683A3436257D2E666C69702D632D636F6C2D377B77696474683A35342E3333257D2E666C69702D632D636F6C2D387B77696474683A36322E3636257D2E66';
wwv_flow_api.g_varchar2_table(15) := '6C69702D632D636F6C2D397B77696474683A3731257D2E666C69702D632D636F6C2D31307B77696474683A37392E3333257D2E666C69702D632D636F6C2D31317B77696474683A38372E3636257D2E666C69702D632D636F6C2D31327B77696474683A39';
wwv_flow_api.g_varchar2_table(16) := '36257D2E68696464656E2D736D7B646973706C61793A626C6F636B7D7D6469762E6D61742D666C69702D63617264737B6D617267696E3A30206175746F3B6D61782D77696474683A313030253B746578742D616C69676E3A63656E7465727D6469762E6D';
wwv_flow_api.g_varchar2_table(17) := '61742D666C69702D636172647B6D617267696E3A3870783B77696474683A313030253B2D7765626B69742D70657273706563746976653A313030303B70657273706563746976653A313030303B706F736974696F6E3A72656C61746976653B746578742D';
wwv_flow_api.g_varchar2_table(18) := '616C69676E3A6C6566743B7472616E736974696F6E3A616C6C202E337320307320656173652D696E3B7A2D696E6465783A313B626F726465723A31707820736F6C6964207267626128302C302C302C2E303735293B626F726465722D7261646975733A34';
wwv_flow_api.g_varchar2_table(19) := '70783B637572736F723A706F696E7465723B626F782D736861646F773A302031367078203234707820327078207472616E73706172656E742C3020367078203330707820357078207267626128302C302C302C2E3132292C30203870782031307078202D';
wwv_flow_api.g_varchar2_table(20) := '377078207267626128302C302C302C2E32297D6469762E6D61742D666C69702D6361726420696D677B77696474683A313030253B626F726465722D746F702D6C6566742D7261646975733A3470783B626F726465722D746F702D72696768742D72616469';
wwv_flow_api.g_varchar2_table(21) := '75733A3470787D6469762E6D61742D666C69702D63617264206469762E6D61742D666C69702D636172642D7469746C657B6261636B67726F756E643A236666663B70616464696E673A367078203135707820313070783B706F736974696F6E3A72656C61';
wwv_flow_api.g_varchar2_table(22) := '746976653B7A2D696E6465783A303B626F726465722D626F74746F6D2D6C6566742D7261646975733A3470783B626F726465722D626F74746F6D2D72696768742D7261646975733A3470787D6469762E6D61742D666C69702D63617264206469762E6D61';
wwv_flow_api.g_varchar2_table(23) := '742D666C69702D636172642D7469746C652D746578747B6C696E652D6865696768743A312E353B666F6E742D73697A653A3272656D3B6D617267696E3A30203020312E3272656D7D6469762E6D61742D666C69702D63617264206469762E6D61742D666C';
wwv_flow_api.g_varchar2_table(24) := '69702D636172642D7469746C652068327B746578742D6F766572666C6F773A656C6C69707369733B77686974652D73706163653A6E6F777261703B6F766572666C6F773A68696464656E3B6D617267696E2D72696768743A333070787D6469762E6D6174';
wwv_flow_api.g_varchar2_table(25) := '2D666C69702D63617264206469762E6D61742D666C69702D636172642D7469746C6520612E746F67676C652D696E666F7B626F726465722D7261646975733A333270783B6865696768743A333270783B70616464696E673A303B706F736974696F6E3A61';
wwv_flow_api.g_varchar2_table(26) := '62736F6C7574653B72696768743A313570783B746F703A313070783B77696474683A333270787D6469762E6D61742D666C69702D63617264206469762E6D61742D666C69702D636172642D7469746C6520612E746F67676C652D696E666F207370616E7B';
wwv_flow_api.g_varchar2_table(27) := '6261636B67726F756E643A236666663B646973706C61793A626C6F636B3B6865696768743A3270783B706F736974696F6E3A6162736F6C7574653B746F703A313670783B7472616E736974696F6E3A616C6C202E31357320307320656173652D6F75743B';
wwv_flow_api.g_varchar2_table(28) := '77696474683A313270787D6469762E6D61742D666C69702D63617264206469762E6D61742D666C69702D636172642D7469746C6520612E746F67676C652D696E666F207370616E2E6C6566747B72696768743A313470783B2D7765626B69742D7472616E';
wwv_flow_api.g_varchar2_table(29) := '73666F726D3A726F74617465283435646567293B7472616E73666F726D3A726F74617465283435646567297D6469762E6D61742D666C69702D63617264206469762E6D61742D666C69702D636172642D7469746C6520612E746F67676C652D696E666F20';
wwv_flow_api.g_varchar2_table(30) := '7370616E2E72696768747B6C6566743A313470783B2D7765626B69742D7472616E73666F726D3A726F74617465282D3435646567293B7472616E73666F726D3A726F74617465282D3435646567297D6469762E6D61742D666C69702D6361726420646976';
wwv_flow_api.g_varchar2_table(31) := '2E6D61742D666C69702D636172642D6465736372697074696F6E7B70616464696E673A323070783B706F736974696F6E3A72656C61746976653B626F726465723A31707820736F6C6964207267626128302C302C302C2E303735293B626F726465722D62';
wwv_flow_api.g_varchar2_table(32) := '6F74746F6D2D6C6566742D7261646975733A3470783B626F726465722D626F74746F6D2D72696768742D7261646975733A3470787D6469762E6D61742D666C69702D63617264206469762E6D61742D666C69702D636172642D616374696F6E737B626F78';
wwv_flow_api.g_varchar2_table(33) := '2D736861646F773A302032707820302030207267626128302C302C302C2E303735293B70616464696E673A31307078203135707820323070783B746578742D616C69676E3A63656E7465727D6469762E6D61742D666C69702D63617264206469762E6D61';
wwv_flow_api.g_varchar2_table(34) := '742D666C69702D636172642D666C61707B6261636B67726F756E643A236439643964393B706F736974696F6E3A6162736F6C7574653B77696474683A313030253B2D7765626B69742D7472616E73666F726D2D6F726967696E3A746F703B7472616E7366';
wwv_flow_api.g_varchar2_table(35) := '6F726D2D6F726967696E3A746F703B2D7765626B69742D7472616E73666F726D3A726F7461746558282D3930646567293B7472616E73666F726D3A726F7461746558282D3930646567297D6469762E6D61742D666C69702D63617264206469762E666C61';
wwv_flow_api.g_varchar2_table(36) := '70317B7472616E736974696F6E3A616C6C202E3373202E337320656173652D6F75743B7A2D696E6465783A2D317D6469762E6D61742D666C69702D63617264732E73686F77696E67206469762E6D61742D666C69702D636172647B637572736F723A706F';
wwv_flow_api.g_varchar2_table(37) := '696E7465723B6F7061636974793A2E383B2D7765626B69742D7472616E73666F726D3A7363616C65282E3934293B7472616E73666F726D3A7363616C65282E3934297D2E6E6F2D746F756368206469762E6D61742D666C69702D63617264732E73686F77';
wwv_flow_api.g_varchar2_table(38) := '696E67206469762E6D61742D666C69702D636172643A686F7665727B6F7061636974793A2E373B2D7765626B69742D7472616E73666F726D3A7363616C65282E34293B7472616E73666F726D3A7363616C65282E34297D6469762E6D61742D666C69702D';
wwv_flow_api.g_varchar2_table(39) := '636172642E73686F777B6F7061636974793A3121696D706F7274616E743B2D7765626B69742D7472616E73666F726D3A7363616C6528312921696D706F7274616E743B7472616E73666F726D3A7363616C6528312921696D706F7274616E747D6469762E';
wwv_flow_api.g_varchar2_table(40) := '6D61742D666C69702D636172642E73686F77206469762E6D61742D666C69702D636172642D7469746C6520612E746F67676C652D696E666F7B6261636B67726F756E643A2366363621696D706F7274616E747D6469762E6D61742D666C69702D63617264';
wwv_flow_api.g_varchar2_table(41) := '2E73686F77206469762E6D61742D666C69702D636172642D7469746C6520612E746F67676C652D696E666F207370616E7B746F703A313570787D6469762E6D61742D666C69702D636172642E73686F77206469762E6D61742D666C69702D636172642D74';
wwv_flow_api.g_varchar2_table(42) := '69746C6520612E746F67676C652D696E666F207370616E2E6C6566747B72696768743A313070787D6469762E6D61742D666C69702D636172642E73686F77206469762E6D61742D666C69702D636172642D7469746C6520612E746F67676C652D696E666F';
wwv_flow_api.g_varchar2_table(43) := '207370616E2E72696768747B6C6566743A313070787D6469762E6D61742D666C69702D636172642E73686F77206469762E6D61742D666C69702D636172642D666C61707B6261636B67726F756E643A236666663B2D7765626B69742D7472616E73666F72';
wwv_flow_api.g_varchar2_table(44) := '6D3A726F74617465582830293B7472616E73666F726D3A726F74617465582830297D6469762E6D61742D666C69702D636172642E73686F77206469762E666C6170317B7472616E736974696F6E3A616C6C202E337320307320656173652D6F75747D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(36281040665894591671)
,p_plugin_id=>wwv_flow_api.id(91165580813989192805)
,p_file_name=>'flipcards.pkgd.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7661722061706578466C697043617264733D66756E6374696F6E28297B2275736520737472696374223B66756E6374696F6E20612861297B76617220653D2428223C6469763E3C2F6469763E22293B72657475726E20652E616464436C6173732822666C';
wwv_flow_api.g_varchar2_table(2) := '69702D632D726F7722292C612E617070656E642865292C657D66756E6374696F6E206528652C732C722C6E297B76617220743D242865293B742E706172656E7428292E63737328226F766572666C6F77222C22696E686572697422293B76617220693D66';
wwv_flow_api.g_varchar2_table(3) := '756E6374696F6E2861297B76617220653D2428223C6469763E3C2F6469763E22293B72657475726E20652E616464436C6173732822666C69702D632D636F6E7461696E657222292C612E617070656E642865292C657D2874292C6F3D612869292C643D30';
wwv_flow_api.g_varchar2_table(4) := '3B242E6561636828732C66756E6374696F6E28652C73297B642B3D6E2E6361726457696474683B76617220633D2428223C6469763E3C2F6469763E22293B632E616464436C6173732822666C69702D632D636F6C2D222B6E2E636172645769647468293B';
wwv_flow_api.g_varchar2_table(5) := '766172206C3D2428223C6469763E3C2F6469763E22293B6C2E616464436C61737328226D61742D666C69702D6361726422293B76617220703D2428223C696D673E22293B702E616464436C61737328226D61742D666C69702D636172645F5F696D616765';
wwv_flow_api.g_varchar2_table(6) := '22292C702E617474722822737263222C732E494D475F535243292C6C2E617070656E642870293B76617220683D2428223C6469763E3C2F6469763E22293B682E616464436C61737328226D61742D666C69702D636172642D7469746C6522293B76617220';
wwv_flow_api.g_varchar2_table(7) := '663D2428223C613E3C2F613E22293B662E616464436C6173732822746F67676C652D696E666F22292C662E616464436C617373282262746E22293B76617220763D2428223C7370616E3E3C2F7370616E3E22293B762E616464436C61737328226C656674';
wwv_flow_api.g_varchar2_table(8) := '22292C662E617070656E642876293B76617220673D2428223C7370616E3E3C2F7370616E3E22293B672E616464436C6173732822726967687422292C662E617070656E642867292C682E617070656E642866293B76617220433D2428223C6469763E3C2F';
wwv_flow_api.g_varchar2_table(9) := '6469763E22293B432E616464436C61737328226D61742D666C69702D636172642D7469746C652D7465787422292C2131213D3D723F432E7465787428732E5449544C45293A432E68746D6C28732E5449544C45292C682E617070656E642843292C6C2E61';
wwv_flow_api.g_varchar2_table(10) := '7070656E642868293B76617220753D2428223C6469763E3C2F6469763E22293B752E616464436C61737328226D61742D666C69702D636172642D666C617022292C752E616464436C6173732822666C61703122292C732E444553435F4241434B5F434F4C';
wwv_flow_api.g_varchar2_table(11) := '4F522626732E444553435F4241434B5F434F4C4F522E6C656E6774683E302626752E63737328226261636B67726F756E64222C732E444553435F4241434B5F434F4C4F52292C732E444553435F464F4E545F434F4C4F522626732E444553435F464F4E54';
wwv_flow_api.g_varchar2_table(12) := '5F434F4C4F522E6C656E6774683E302626752E6373732822636F6C6F72222C732E444553435F464F4E545F434F4C4F52293B766172206D3D2428223C6469763E3C2F6469763E22293B6D2E616464436C61737328226D61742D666C69702D636172642D64';
wwv_flow_api.g_varchar2_table(13) := '65736372697074696F6E22292C2131213D3D723F6D2E7465787428732E4445534352495054494F4E293A6D2E68746D6C28732E4445534352495054494F4E292C752E617070656E64286D292C6C2E617070656E642875292C632E617070656E64286C292C';
wwv_flow_api.g_varchar2_table(14) := '6F2E617070656E642863292C643E3D31322626286F3D612869292C643D30293B76617220783D31303B6C2E636C69636B2866756E6374696F6E2861297B612E70726576656E7444656661756C7428293B76617220653D21313B696628242874686973292E';
wwv_flow_api.g_varchar2_table(15) := '686173436C617373282273686F772229262628653D2130292C742E686173436C617373282273686F77696E672229297B76617220733D742E66696E6428222E73686F7722293B732E72656D6F7665436C617373282273686F7722292C242E656163682873';
wwv_flow_api.g_varchar2_table(16) := '2C66756E6374696F6E28612C65297B76617220733D242865292E66696E6428222E6D61742D666C69702D636172642D7469746C6522292C723D242865292E66696E6428222E6D61742D666C69702D636172645F5F696D61676522293B242874686973292E';
wwv_flow_api.g_varchar2_table(17) := '686569676874284D6174682E666C6F6F7228732E68656967687428292B722E686569676874282929297D292C653F742E72656D6F7665436C617373282273686F77696E6722293A28242874686973292E637373287B7A496E6465783A787D292C24287468';
wwv_flow_api.g_varchar2_table(18) := '6973292E616464436C617373282273686F7722292C242874686973292E686569676874284D6174682E666C6F6F7228682E68656967687428292B702E68656967687428292B752E68656967687428292929292C782B2B7D656C736520742E616464436C61';
wwv_flow_api.g_varchar2_table(19) := '7373282273686F77696E6722292C242874686973292E637373287B7A496E6465783A787D292C242874686973292E616464436C617373282273686F7722292C242874686973292E686569676874284D6174682E666C6F6F7228682E68656967687428292B';
wwv_flow_api.g_varchar2_table(20) := '702E68656967687428292B752E686569676874282929292C782B2B7D297D297D76617220733D7B76657273696F6E3A22312E302E35222C6973415045583A66756E6374696F6E28297B72657475726E22756E646566696E656422213D747970656F662061';
wwv_flow_api.g_varchar2_table(21) := '7065787D2C64656275673A7B696E666F3A66756E6374696F6E2861297B732E69734150455828292626617065782E64656275672E696E666F2861297D2C6572726F723A66756E6374696F6E2861297B732E69734150455828293F617065782E6465627567';
wwv_flow_api.g_varchar2_table(22) := '2E6572726F722861293A636F6E736F6C652E6572726F722861297D7D2C6C6F616465723A7B73746172743A66756E6374696F6E2861297B696628732E697341504558282929617065782E7574696C2E73686F775370696E6E65722824286129293B656C73';
wwv_flow_api.g_varchar2_table(23) := '657B76617220653D2428223C7370616E3E3C2F7370616E3E22293B652E6174747228226964222C226C6F61646572222B61292C652E616464436C617373282263742D6C6F6164657222293B76617220723D2428223C693E3C2F693E22293B722E61646443';
wwv_flow_api.g_varchar2_table(24) := '6C617373282266612066612D726566726573682066612D32782066612D616E696D2D7370696E22292C722E63737328226261636B67726F756E64222C2272676261283132312C3132312C3132312C302E362922292C722E6373732822626F726465722D72';
wwv_flow_api.g_varchar2_table(25) := '6164697573222C223130302522292C722E637373282270616464696E67222C223135707822292C722E6373732822636F6C6F72222C22776869746522292C652E617070656E642872292C242861292E617070656E642865297D7D2C73746F703A66756E63';
wwv_flow_api.g_varchar2_table(26) := '74696F6E2861297B2428612B22203E202E752D50726F63657373696E6722292E72656D6F766528292C2428612B22203E202E63742D6C6F6164657222292E72656D6F766528297D7D2C6A736F6E53617665457874656E643A66756E6374696F6E28612C65';
wwv_flow_api.g_varchar2_table(27) := '297B76617220733D7B7D3B69662822737472696E67223D3D747970656F662065297472797B653D4A534F4E2E70617273652865297D63617463682861297B636F6E736F6C652E6572726F7228224572726F72207768696C652074727920746F2070617273';
wwv_flow_api.g_varchar2_table(28) := '6520746172676574436F6E6669672E20506C6561736520636865636B20796F757220436F6E666967204A534F4E2E205374616E6461726420436F6E6669672077696C6C20626520757365642E22292C636F6E736F6C652E6572726F722861292C636F6E73';
wwv_flow_api.g_varchar2_table(29) := '6F6C652E6572726F722865297D656C736520733D653B7472797B733D242E657874656E642821302C612C65297D63617463682865297B636F6E736F6C652E6572726F7228224572726F72207768696C652074727920746F206D657267652032204A534F4E';
wwv_flow_api.g_varchar2_table(30) := '7320696E746F207374616E64617264204A534F4E20696620616E7920617474726962757465206973206D697373696E672E20506C6561736520636865636B20796F757220436F6E666967204A534F4E2E205374616E6461726420436F6E6669672077696C';
wwv_flow_api.g_varchar2_table(31) := '6C20626520757365642E22292C636F6E736F6C652E6572726F722865292C733D612C636F6E736F6C652E6572726F722873297D72657475726E20737D2C6E6F446174614D6573736167653A7B73686F773A66756E6374696F6E28612C65297B7661722073';
wwv_flow_api.g_varchar2_table(32) := '3D2428223C6469763E3C2F6469763E22292E63737328226D617267696E222C223132707822292E6373732822746578742D616C69676E222C2263656E74657222292E637373282270616464696E67222C2236347078203022292E616464436C6173732822';
wwv_flow_api.g_varchar2_table(33) := '6E6F64617461666F756E646D65737361676522292C723D2428223C6469763E3C2F6469763E22292C6E3D2428223C7370616E3E3C2F7370616E3E22292E616464436C6173732822666122292E616464436C617373282266612D73656172636822292E6164';
wwv_flow_api.g_varchar2_table(34) := '64436C617373282266612D327822292E6373732822686569676874222C223332707822292E63737328227769647468222C223332707822292E6373732822636F6C6F72222C222344304430443022292E63737328226D617267696E2D626F74746F6D222C';
wwv_flow_api.g_varchar2_table(35) := '223136707822293B722E617070656E64286E293B76617220743D2428223C7370616E3E3C2F7370616E3E22292E746578742865292E6373732822646973706C6179222C22626C6F636B22292E6373732822636F6C6F72222C222337303730373022292E63';
wwv_flow_api.g_varchar2_table(36) := '73732822666F6E742D73697A65222C223132707822293B732E617070656E642872292E617070656E642874292C242861292E617070656E642873297D2C686964653A66756E6374696F6E2861297B242861292E6368696C6472656E28222E6E6F64617461';
wwv_flow_api.g_varchar2_table(37) := '666F756E646D65737361676522292E72656D6F766528297D7D7D3B72657475726E7B72656E6465723A66756E6374696F6E28612C722C6E2C742C692C6F297B66756E6374696F6E206428297B242863292E63737328226D696E2D686569676874222C2231';
wwv_flow_api.g_varchar2_table(38) := '3230707822292C732E6C6F616465722E73746172742863293B76617220613D743B7472797B617065782E7365727665722E706C7567696E28722C7B706167654974656D733A617D2C7B737563636573733A66756E6374696F6E2861297B2166756E637469';
wwv_flow_api.g_varchar2_table(39) := '6F6E28612C722C6E2C742C69297B242861292E656D70747928292C722E726F772626722E726F772E6C656E6774683E303F6528612C722E726F772C742C69293A28242861292E63737328226D696E2D686569676874222C2222292C732E6E6F446174614D';
wwv_flow_api.g_varchar2_table(40) := '6573736167652E73686F7728612C6E29292C732E6C6F616465722E73746F702861297D28632C612C6E2C692C6C297D2C6572726F723A66756E6374696F6E2861297B636F6E736F6C652E6572726F7228612E726573706F6E736554657874297D2C646174';
wwv_flow_api.g_varchar2_table(41) := '61547970653A226A736F6E227D297D63617463682861297B636F6E736F6C652E6572726F7228224572726F72207768696C652074727920746F2067657420446174612066726F6D204150455822292C636F6E736F6C652E6572726F722861297D7D766172';
wwv_flow_api.g_varchar2_table(42) := '20633D2223222B612B222D70222C6C3D7B7D3B6C3D732E6A736F6E53617665457874656E64287B6361726457696474683A342C726566726573683A307D2C6F292C6428293B7472797B617065782E6A5175657279282223222B61292E62696E6428226170';
wwv_flow_api.g_varchar2_table(43) := '657872656672657368222C66756E6374696F6E28297B6428297D297D63617463682861297B636F6E736F6C652E6572726F7228224572726F72207768696C652074727920746F2062696E6420415045582072656672657368206576656E7422292C636F6E';
wwv_flow_api.g_varchar2_table(44) := '736F6C652E6572726F722861297D6C2E7265667265736826266C2E726566726573683E302626736574496E74657276616C2866756E6374696F6E28297B6428297D2C3165332A6C2E72656672657368297D7D7D28293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(36281040993305591682)
,p_plugin_id=>wwv_flow_api.id(91165580813989192805)
,p_file_name=>'flipcards.pkgd.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '4D4954204C6963656E73650A0A436F7079726967687420286329203230313920526F6E6E792057656973730A0A5065726D697373696F6E20697320686572656279206772616E7465642C2066726565206F66206368617267652C20746F20616E79207065';
wwv_flow_api.g_varchar2_table(2) := '72736F6E206F627461696E696E67206120636F70790A6F66207468697320736F66747761726520616E64206173736F63696174656420646F63756D656E746174696F6E2066696C657320287468652022536F66747761726522292C20746F206465616C0A';
wwv_flow_api.g_varchar2_table(3) := '696E2074686520536F66747761726520776974686F7574207265737472696374696F6E2C20696E636C7564696E6720776974686F7574206C696D69746174696F6E20746865207269676874730A746F207573652C20636F70792C206D6F646966792C206D';
wwv_flow_api.g_varchar2_table(4) := '657267652C207075626C6973682C20646973747269627574652C207375626C6963656E73652C20616E642F6F722073656C6C0A636F70696573206F662074686520536F6674776172652C20616E6420746F207065726D697420706572736F6E7320746F20';
wwv_flow_api.g_varchar2_table(5) := '77686F6D2074686520536F6674776172652069730A6675726E697368656420746F20646F20736F2C207375626A65637420746F2074686520666F6C6C6F77696E6720636F6E646974696F6E733A0A0A5468652061626F766520636F70797269676874206E';
wwv_flow_api.g_varchar2_table(6) := '6F7469636520616E642074686973207065726D697373696F6E206E6F74696365207368616C6C20626520696E636C7564656420696E20616C6C0A636F70696573206F72207375627374616E7469616C20706F7274696F6E73206F662074686520536F6674';
wwv_flow_api.g_varchar2_table(7) := '776172652E0A0A54484520534F4654574152452049532050524F564944454420224153204953222C20574954484F55542057415252414E5459204F4620414E59204B494E442C2045585052455353204F520A494D504C4945442C20494E434C5544494E47';
wwv_flow_api.g_varchar2_table(8) := '20425554204E4F54204C494D4954454420544F205448452057415252414E54494553204F46204D45524348414E544142494C4954592C0A4649544E45535320464F52204120504152544943554C415220505552504F534520414E44204E4F4E494E465249';
wwv_flow_api.g_varchar2_table(9) := '4E47454D454E542E20494E204E4F204556454E54205348414C4C205448450A415554484F5253204F5220434F5059524947485420484F4C44455253204245204C4941424C4520464F5220414E5920434C41494D2C2044414D41474553204F52204F544845';
wwv_flow_api.g_varchar2_table(10) := '520A4C494142494C4954592C205748455448455220494E20414E20414354494F4E204F4620434F4E54524143542C20544F5254204F52204F54484552574953452C2041524953494E472046524F4D2C0A4F5554204F46204F5220494E20434F4E4E454354';
wwv_flow_api.g_varchar2_table(11) := '494F4E20574954482054484520534F465457415245204F522054484520555345204F52204F54484552204445414C494E475320494E205448450A534F4654574152452E0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(68100724389191243506)
,p_plugin_id=>wwv_flow_api.id(91165580813989192805)
,p_file_name=>'LICENSE'
,p_mime_type=>'application/octet-stream'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := 'EFBBBF5468616E6B7320666F72206578616D706C65206F6E20636F646570656E2E696F3A0D0A0D0A334420466F6C64206F75742072657665616C0D0A412050454E20425920416E647265772043616E68616D0D0A0D0A68747470733A2F2F636F64657065';
wwv_flow_api.g_varchar2_table(2) := '6E2E696F2F63616E64726F6F2F70656E2F774B4577524C0D0A68747470733A2F2F626C6F672E636F646570656E2E696F2F6C6567616C2F6C6963656E73696E672F0D0A0D0A436F70797269676874202863292032303139202D20416E647265772043616E';
wwv_flow_api.g_varchar2_table(3) := '68616D202D2068747470733A2F2F636F646570656E2E696F2F63616E64726F6F2F70656E2F774B4577524C0D0A0D0A5065726D697373696F6E20697320686572656279206772616E7465642C2066726565206F66206368617267652C20746F20616E7920';
wwv_flow_api.g_varchar2_table(4) := '706572736F6E200D0A6F627461696E696E67206120636F7079206F66207468697320736F66747761726520616E64206173736F63696174656420646F63756D656E746174696F6E200D0A66696C657320287468652022536F66747761726522292C20746F';
wwv_flow_api.g_varchar2_table(5) := '206465616C20696E2074686520536F66747761726520776974686F7574207265737472696374696F6E2C0D0A20696E636C7564696E6720776974686F7574206C696D69746174696F6E207468652072696768747320746F207573652C20636F70792C206D';
wwv_flow_api.g_varchar2_table(6) := '6F646966792C200D0A6D657267652C207075626C6973682C20646973747269627574652C207375626C6963656E73652C20616E642F6F722073656C6C20636F70696573206F66200D0A74686520536F6674776172652C20616E6420746F207065726D6974';
wwv_flow_api.g_varchar2_table(7) := '20706572736F6E7320746F2077686F6D2074686520536F667477617265206973200D0A6675726E697368656420746F20646F20736F2C207375626A65637420746F2074686520666F6C6C6F77696E6720636F6E646974696F6E733A0D0A0D0A5468652061';
wwv_flow_api.g_varchar2_table(8) := '626F766520636F70797269676874206E6F7469636520616E642074686973207065726D697373696F6E206E6F74696365207368616C6C200D0A626520696E636C7564656420696E20616C6C20636F70696573206F72207375627374616E7469616C20706F';
wwv_flow_api.g_varchar2_table(9) := '7274696F6E73206F662074686520536F6674776172652E0D0A0D0A54484520534F4654574152452049532050524F564944454420224153204953222C20574954484F55542057415252414E5459204F4620414E59204B494E442C200D0A45585052455353';
wwv_flow_api.g_varchar2_table(10) := '204F5220494D504C4945442C20494E434C5544494E4720425554204E4F54204C494D4954454420544F205448452057415252414E54494553200D0A4F46204D45524348414E544142494C4954592C204649544E45535320464F5220412050415254494355';
wwv_flow_api.g_varchar2_table(11) := '4C415220505552504F534520414E44200D0A4E4F4E494E4652494E47454D454E542E20494E204E4F204556454E54205348414C4C2054484520415554484F5253204F5220434F50595249474854200D0A484F4C44455253204245204C4941424C4520464F';
wwv_flow_api.g_varchar2_table(12) := '5220414E5920434C41494D2C2044414D41474553204F52204F54484552204C494142494C4954592C200D0A5748455448455220494E20414E20414354494F4E204F4620434F4E54524143542C20544F5254204F52204F54484552574953452C2041524953';
wwv_flow_api.g_varchar2_table(13) := '494E472046524F4D2C200D0A4F5554204F46204F5220494E20434F4E4E454354494F4E20574954482054484520534F465457415245204F522054484520555345204F52204F54484552200D0A4445414C494E475320494E2054484520534F465457415245';
wwv_flow_api.g_varchar2_table(14) := '2E0D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(68100724753309243508)
,p_plugin_id=>wwv_flow_api.id(91165580813989192805)
,p_file_name=>'LICENSE4LIBS'
,p_mime_type=>'application/octet-stream'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
