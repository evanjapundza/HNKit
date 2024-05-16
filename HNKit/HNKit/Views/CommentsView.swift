//
//  CommentsView.swift
//  HNKit
//
//  Created by Evan Japundza on 4/2/24.
//

import SwiftUI

struct CommentsView: View {
    @EnvironmentObject var viewModel: HackerNewsViewModel
    
    var storyID: Int
    @State var isLoading = true
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    Text("Comments")
                        .bold()
                        .padding()
                    
                    Divider()
                    ForEach(viewModel.storyComments) { comment in
                        VStack {
                            
                            CommentView(comment: comment, indentationLevel: 0)
                                .padding(10)
                            
                            Divider()
                        }
                    }
                    
                }
            }
            .onAppear {
                viewModel.fetchTopLevelComments(for: storyID) {
                    isLoading = false
                }
            }
        }
    }
}

struct CommentView: View {
    let comment: Comment
    let indentationLevel: Int
    @State private var plainText: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                switch indentationLevel {
                case 0:
                    Rectangle()
                        .foregroundStyle(.purple)
                        .frame(width: 2)
                case 1:
                    Rectangle()
                        .foregroundStyle(.blue)
                        .frame(width: 2)
                case 2:
                    Rectangle()
                        .foregroundStyle(.orange)
                        .frame(width: 2)
                case 3:
                    Rectangle()
                        .foregroundStyle(.green)
                        .frame(width: 2)
                case 4:
                    Rectangle()
                        .foregroundStyle(.red)
                        .frame(width: 2)
                case 5:
                    Rectangle()
                        .foregroundStyle(.yellow)
                        .frame(width: 2)
                case 6:
                    Rectangle()
                        .foregroundStyle(.cyan)
                        .frame(width: 2)
                default:
                    Rectangle()
                        .foregroundStyle(.gray)
                        .frame(width: 2)
                }
                  
                VStack {
                    HStack {
                        Text(comment.by)
                            .bold()
                        Text("•")
                        Text(comment.relativeTimeString)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text(plainText)
                            .font(.body)
                            .lineLimit(nil)
                            .textSelection(.enabled)
                        Spacer()
                    }
                    
                    if let nestedComments = comment.nestedComments {
                        ForEach(nestedComments) { nestedComment in
                            CommentView(comment: nestedComment, indentationLevel: indentationLevel + 1)
                                .padding(10)
                            
                        }
                    }
                    
                }
                .onAppear {
                    DispatchQueue.global(qos: .userInitiated).async {
                        let text = comment.text.html2String
                        DispatchQueue.main.async {
                            self.plainText = text
                        }
                    }
                }
            }
//            .frame(maxHeight: .infinity)
//            .padding(.leading, CGFloat(indentationLevel) * 10)
//            .offset(x: CGFloat(indentationLevel)*20)
            
            
        }
        .fixedSize(horizontal: false, vertical: true)
//        .frame(maxHeight: .infinity)
    }
}
//
#Preview {
    CommentsView(storyID: 8863)
        .environmentObject(HackerNewsViewModel())
}
