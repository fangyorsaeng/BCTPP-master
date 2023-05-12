pageextension 50027 "Document Attach Ex" extends "Document Attachment Details"
{
    layout
    {
        addafter(Name)
        {
            field("Document Type"; "Document Type")
            {
                ApplicationArea = all;
            }
        }
    }
}