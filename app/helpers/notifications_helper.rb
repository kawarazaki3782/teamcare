module NotificationsHelper
  def notification_form(notification)
    @visiter = notification.visiter
    @comment = nil
    your_post = link_to 'あなたの投稿', micropost_path(notification), style: 'font-weight: bold;', remote: true
    your_diary = link_to 'あなたの日記', diary_path(notification), style: 'font-weight: bold;', remote: true
    @visiter_comment = notification.comment_id
    # notification.actionがfollowかlikeかcommentか
    case notification.action
    when 'follow'
      tag.a(notification.visiter.name, style: 'font-weight: bold;') + 'があなたをフォローしました'
    when 'micropost_like'
      tag.a(notification.visiter.name,
            style: 'font-weight: bold;') + 'が' + tag.a('あなたの投稿', href: micropost_path(notification.micropost_id),
                                                                 style: 'font-weight: bold;') + 'にいいねしました'
    when 'diary_like'
      tag.a(notification.visiter.name,
            style: 'font-weight: bold;') + 'が' + tag.a('あなたの日記', href: diary_path(notification.diary_id),
                                                                 style: 'font-weight: bold;') + 'にいいねしました'
    when 'micropost_comment'
      @comment = Comment.find_by(id: @visiter_comment)&.content
      tag.a(@visiter.name,
            style: 'font-weight: bold;') + 'が' + tag.a('あなたの投稿', href: micropost_path(notification.micropost_id),
                                                                 style: 'font-weight: bold;') + 'にコメントしました'
    when 'diary_comment'
      @comment = Comment.find_by(id: @visiter_comment)&.content
      tag.a(@visiter.name,
            style: 'font-weight: bold;') + 'が' + tag.a('あなたの投稿', href: diary_path(notification.diary_id),
                                                                 style: 'font-weight: bold;') + 'にコメントしました'
    when 'help'
      tag.a(notification.visiter.name, style: 'font-weight: bold;') + 'が助けを呼んでいます、声をかけましょう'         
    
    when 'dm'
      tag.a(notification.visiter.name, style: 'font-weight: bold;') + 'からメッセージが届きました'         
    end
  end

  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end
end
