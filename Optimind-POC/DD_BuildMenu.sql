IF EXISTS ( SELECT   *
            FROM     SYSOBJECTS
            WHERE    type = 'P'
                     AND [id] = OBJECT_ID('DD_BuildMenu') ) 
   DROP PROCEDURE DD_BuildMenu
GO

CREATE PROCEDURE DD_BuildMenu ( 
                                @ulID   VARCHAR(50),        -- ID of the whole menu
                                @ulClass VARCHAR(50) = NULL -- Class of the whole menu...Optional parameter
                              )
/*********************************************************************************
BS"D
AUTHOR: Avraham Toledano
Date:   2012-02-02

Description: Dynamically creates the HTML tags for Unsorted list
                needed to create menus & sub-menus.
            For now....deals ONLY with 2 levels...will be soon modified BZ"H                

Version: 1.0

Updates: NONE.
*********************************************************************************/
AS 
    BEGIN

        DECLARE @menuID INT ,
            @menuName VARCHAR(50) ,
            @menuLevel INT ,
            @menuParent INT ,
            @menuSeq INT ,
            @menuClass VARCHAR(50) ,
            @menuLink VARCHAR(150) ,
            @menuTarget VARCHAR(50)

        DECLARE @subMenuID INT ,
            @subMenuName VARCHAR(50) ,
            @subMenuLevel INT ,
            @subMenuParent INT ,
            @subMenuSeq INT ,
            @subMenuClass VARCHAR(50) ,
            @subMenuLink VARCHAR(150) ,
            @subMenuTarget VARCHAR(50)

        DECLARE @class VARCHAR(15),
				@ulMenu VARCHAR(MAX),
				@JSscript VARCHAR(MAX),
				@mainCNT SMALLINT,
				@subCNT SMALLINT,
				@active VARCHAR(10),
				@classSTR VARCHAR(50)
 

        SELECT  @ulMenu = '' ,
                @ulClass = LTRIM(RTRIM(@ulClass)),
                @ulID =  LTRIM(RTRIM(@ulID)),
                @class = ' class= "'


        DECLARE mainMenu_cursor CURSOR FOR
        SELECT menuID, menuName, menuLevel, menuParent, menuSeq, menuClass, menuLink, menuTarget
        FROM wtMenus WITH (NOLOCK) 
        WHERE ISNULL(menuParent, 0) = 0
        ORDER BY menuSeq

        OPEN mainMenu_cursor   
        FETCH NEXT FROM mainMenu_cursor INTO @menuID, @menuName, @menuLevel, @menuParent, @menuSeq, @menuClass, @menuLink, @menuTarget  

		SET @mainCNT = @@ROWCOUNT
		IF (@mainCNT > 0)
		    BEGIN	
			    --Set external <ul> tag for the WHOLE menu
			    SELECT  @ulMenu = SPACE(4)
			                     + '<ul' + ISNULL(' id= "' + @ulID + '"', '') 
			                     + ISNULL(@class + @ulClass +'"', '')
							     + '>' + CHAR(13)
        END
		ELSE 
			GOTO ENDjob -- NO menus :-)
			
        WHILE @@FETCH_STATUS = 0 
            BEGIN 
                SELECT  @active =  CASE ( @menuLevel + @menuSeq )
                                            WHEN 0 THEN ' active'
                                            ELSE NULL
                                            END
                                                            
                SELECT  @ulMenu = @ulMenu + SPACE(8) + '<li' 
                        + @class + 'subMenu' + ISNULL(@active, '') + ISNULL(' ' + @menuClass, '') + '">'
                        + '<a href= "' + ISNULL(NULLIF(@menuLink,''), '#') + '"'
                        + ISNULL(' target= "' + @menuTarget + '"', '') + '>' 
                        + @menuName
                        + '</a>' + CHAR(13)


                DECLARE subMenu_cursor CURSOR FOR
                SELECT menuID, menuName, menuLevel, menuParent, menuSeq, menuClass, menuLink, menuTarget
                FROM wtMenus WITH (NOLOCK) 
                WHERE menuParent = @menuID
                ORDER BY menuSeq

                OPEN subMenu_cursor   
                FETCH NEXT FROM subMenu_cursor INTO @subMenuID, @subMenuName, @subMenuLevel, @subMenuParent, @subMenuSeq, @subMenuClass, @subMenuLink, @subMenuTarget  

                --Set <ul> tag for Sub-Menu
				SET @subCNT = @@ROWCOUNT
				IF (@subCNT > 0)	
					SELECT  @ulMenu = @ulMenu + SPACE(12) + '<ul>' + CHAR(13)

                WHILE @@FETCH_STATUS = 0 
                    BEGIN
                        SELECT  @ulMenu = @ulMenu + SPACE(16) + '<li'
                                + ISNULL(@class + @subMenuClass + '"', '') + '>'
                                + '<a href= "' + ISNULL(@subMenuLink, '#') + '"'
                                + ISNULL(' target= "' + @subMenuTarget + '"', '') + '>'
                                + @subMenuName + '</a></li>' + CHAR(13)

                        FETCH NEXT FROM subMenu_cursor INTO @subMenuID, @subMenuName, @subMenuLevel, @subMenuParent, @subMenuSeq, @subMenuClass, @subMenuLink, @subMenuTarget  
                    END   
                IF (@subCNT > 0)
                    -- Close sub-menu <ul> Tag
                    SELECT  @ulMenu = @ulMenu + SPACE(12) + '</ul>' + CHAR(13)
                                        + SPACE(8) + '</li>' + CHAR(13)

                CLOSE subMenu_cursor   
                DEALLOCATE subMenu_cursor

                FETCH NEXT FROM mainMenu_cursor INTO @menuID, @menuName, @menuLevel, @menuParent, @menuSeq, @menuClass, @menuLink, @menuTarget  
            END   
        --Close external <ul> tag for the WHOLE menu
        SELECT  @ulMenu = @ulMenu + + SPACE(4) + '</ul>'

ENDjob:
        CLOSE mainMenu_cursor   
        DEALLOCATE mainMenu_cursor
        
        SELECT @JSscript = '<script type="text/javascript">' + CHAR(13)
                + ' $(function () {' + CHAR(13)
                + '     //Set active menu with appropriate class' + CHAR(13)
                + '     $("#' + @ulID + ' li").click(function () {' + CHAR(13)
                + '         $("li").removeClass("active");' + CHAR(13)
                + '         $(this).addClass("active")' + CHAR(13)
                + '         //Note!!!! the "s" in parents is important to navigate more than one level!!!' + CHAR(13)
                + '         .parents(".subMenu").addClass("active");' + CHAR(13)
                + '     });' + CHAR(13)
                + ' });' + CHAR(13)
                + '</script>'
                
        SELECT '<nav>' + CHAR(13)
               + @ulMenu + CHAR(13)
               + '</nav>' + CHAR(13)
               + @JSscript
        
    END
go        
EXEC DD_BuildMenu 'mainMenu', 'sf-menu clearfix'
GO

