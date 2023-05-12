tableextension 50033 "Assembly Order H" extends "Assembly Header"
{
    fields
    {

        modify("Item No.")
        {
            trigger OnAfterValidate()
            var
                ItemS: Record Item;
            begin
                if "Create By" = '' then begin
                    "Create Date" := CurrentDateTime;
                    "Create By" := utility.UserFullName(UserId);
                end;
                if "Item No." <> '' then begin
                    ItemS.Reset();
                    ItemS.SetRange("No.", "Item No.");
                    if ItemS.Find('-') then begin
                        "Item Category" := ItemS."Item Category Code";
                        "Location Code" := ItemS.Location;
                        "Shortcut Dimension 3 Code" := ItemS."Default Machine";
                        Process := ItemS."Default Process";
                    end;
                end;
            end;
        }
        field(50000; "Create Date"; DateTime)
        {

        }
        field(50001; "Create By"; Text[50])
        {

        }
        field(50010; "Cancel"; Boolean)
        {

        }
        field(50020; "Item Category"; Code[50])
        {
            TableRelation = "Item Category".Code;
        }
        field(50021; "Process"; Code[50])
        {
            TableRelation = "Process List"."Process Name";
        }
        field(50022; "Ref. Part (FG)"; Code[20])
        {
            TableRelation = Item."No." where("Inventory Posting Group" = filter('FG'));
        }
        field(50023; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = 'Machine No.';
            //  Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(50050; "Received Qty"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Production Record Line".Quantity where("Part No." = field("Item No."), "Plan Date" = field("Due Date")));
        }


    }
    trigger OnAfterInsert()
    begin
        if "Create By" = '' then begin
            "Create Date" := CurrentDateTime;
            "Create By" := utility.UserFullName(UserId);
        end;
    end;

    var
        utility: Codeunit Utility;
}