pageextension 50039 "Demand Forecast Card Ex" extends "Demand Forecast Card"
{
    layout
    {
        modify("Quantity Type")
        {
            Visible = false;
        }
        addafter("Date Filter")
        {
            field("Customer Name"; "Customer Name")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Search Name"; "Search Name")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action(ImportExcel)
            {
                ApplicationArea = all;
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Import Excel Forecast';
                trigger OnAction()
                var
                    ImportE: Report "Import Excel Forecasts";
                begin
                    Clear(ImportE);
                    ImportE.setDoc(Name);
                    ImportE.RunModal();
                    CurrPage.Update();
                end;
            }
        }
    }
}