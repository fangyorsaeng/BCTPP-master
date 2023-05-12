table 50030 "Plan Header"
{
    fields
    {
        field(1; "Plan Name"; Code[30])
        {
            NotBlank = true;
            trigger OnValidate()
            begin
                if "Create By" = '' then begin
                    "Create Date" := CurrentDateTime;
                    "Create By" := utility.UserFullName(UserId);
                end;

            end;
        }
        field(2; "Plan Description"; Text[200])
        {

        }
        field(3; "Plan Year"; Enum "Select Year")
        {
            NotBlank = true;
            trigger OnValidate()
            begin
                checkChangeYearMonth();
            end;
        }
        field(4; "Plan Month"; Enum "Select Month")
        {
            NotBlank = true;
            trigger OnValidate()
            begin
                checkChangeYearMonth();
            end;
        }
        field(5; "Section"; Enum "Prod. Process")
        {

        }
        field(6; "Plan Type"; Option)
        {
            OptionMembers = " ",Sales,Factory,Supplier;
        }
        field(7; "Create Date"; DateTime) { Editable = false; }
        field(8; "Create By"; Text[50]) { Editable = false; }
        field(9; "Last Modify By"; Text[50]) { Editable = false; }
        field(10; "Last Modify Date"; DateTime) { Editable = false; }
        field(20; "Use Report"; Text[50]) { }
    }
    keys
    {
        key(key1; "Plan Name") { }
    }
    var
        utility: Codeunit Utility;

    trigger OnDelete()
    var
        PlanLine: Record "Plan Line Sub";
    begin
        PlanLine.Reset();
        PlanLine.SetRange("ref. Plan Name", Rec."Plan Name");
        if NOT PlanLine.IsEmpty then begin
            PlanLine.DeleteAll();
        end;
    end;

    procedure checkChangeYearMonth()
    var
        PlanLine: Record "Plan Line Sub";
    begin
        PlanLine.Reset();
        PlanLine.SetRange("ref. Plan Name", Rec."Plan Name");
        if NOT PlanLine.IsEmpty then begin
            Error('Can not Change You need Delete Line before!!');
        end;
    end;
}