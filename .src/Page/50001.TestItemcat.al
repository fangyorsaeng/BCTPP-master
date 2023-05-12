page 50001 "Item Cat"
{

    ApplicationArea = all;
    Caption = 'Item Cat.';
    Editable = true;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Request Approval,Print/Send,Order,Release,Posting,Navigate';
    QueryCategory = 'Purchase Order List';
    RefreshOnActivate = true;
    SourceTable = "Item Category";
    UsageCategory = Lists;
    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field(Code; Code) { ApplicationArea = all; }
                field(Description; Description) { ApplicationArea = all; }
            }
        }
    }

}