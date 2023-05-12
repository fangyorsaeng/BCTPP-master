page 50015 "Classfication"
{
    PageType = List;
    SourceTable = CLASSFICATION;
    UsageCategory = Lists;
    ApplicationArea = all;
    RefreshOnActivate = true;
    Editable = true;
    InsertAllowed = true;
    DeleteAllowed = true;
    DelayedInsert = true;
    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("No."; "No.") { ApplicationArea = all; }
                field(Code; Code) { ApplicationArea = all; }
                field(Name; Name) { ApplicationArea = all; }
                field(Description; Description) { ApplicationArea = all; }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Import)
            {
                ApplicationArea = all;
                Caption = 'Import';
                Image = Import;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Promoted = true;
                trigger OnAction()
                var
                    ConigP: Page "Config. Packages";
                begin
                    Clear(ConigP);
                    ConigP.Run();
                end;
            }
        }
    }
    var
        utility: Codeunit Utility;

}