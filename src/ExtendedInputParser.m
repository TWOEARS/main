classdef ExtendedInputParser < inputParser
    
    %% ---------------------------------------------------------------------
    methods

        function obj = ExtendedInputParser( )
            obj = obj@inputParser();
            obj.StructExpand = true;
        end
        %% -----------------------------------------------------------------

        function parameters = parseParameters( obj, parameters, setDefaults, varargin )
            obj.parse( varargin{:} );
            ipFieldNames = fieldnames( obj.Results );
            for ii = 1 : length( ipFieldNames )
                isFieldParsedToDefault = any( strcmp( ipFieldNames{ii}, obj.UsingDefaults ) );
                if ~isFieldParsedToDefault || setDefaults
                    parameters.(ipFieldNames{ii}) = obj.Results.(ipFieldNames{ii});
                else
                    continue;
                end
            end
        end
        %% -----------------------------------------------------------------

    end
    
end